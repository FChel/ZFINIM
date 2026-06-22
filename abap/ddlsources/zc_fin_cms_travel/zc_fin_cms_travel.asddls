/*--------------------------------------------------------------------------------------*
* AUTHOR:      180873MC                                                                 *
* DATE:        13/03/2025                                                               *
* WRICEFX-ID:  FINX1275 Employee Travel Payment Request app                             *
* --------------------------------------------------------------------------------------*
* Purpose:     CMS Travel                                                               *
* --------------------------------------------------------------------------------------*
* MODIFICATION HISTORY                                                                  *
* UserID     Date        Transport   Description                                        *
* 180873MC   13/03/2025  S2DK936969  Initial development (Copied from AP Payment        *
*                                    Request)                                           *
* 260971JT   27/05/2025  S2DK937751  Set null Vendor Usernmes to "None". DPE-INC0020476 *
* 270982VK   18/08/2025  S23K901031  T3UP : Fixed Syntax error on PaymentAmount field   *
*                                    by adding Currency Code annotation.                * 
*                                    Also, the annotation ObjectModel.readOnly          *   
*                                    of GLPaymentAmountCurrency is removed(Defect 572)  *
*                                    as it is blanking out the GLPayamentAmount value   *
*                                    after user input.                                  *
* 260971JT   11/07/2025  S2DK938869  Set null Approvers USER IDs to " ". DPE-INC0064190 *
* 190184OOT  28/10/2025  S23K901565  T3UP. Manual retrofit S2DK938869 merged with T3UP  *
*                                    ATC fixes.                                         *
* --------------------------------------------------------------------------------------*/
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Travel Payment Request'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XXL,
    dataClass: #MIXED
}

@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
@ObjectModel: {
  modelCategory: #BUSINESS_OBJECT,
  compositionRoot: true,
  createEnabled: true,
  updateEnabled: true
  }

@Search.searchable: true

define view entity ZC_FIN_CMS_Travel
  as select from ZI_FIN_CMS_Travel_VHs
{
      @ObjectModel.text.association: '_CompanyCode'
      @ObjectModel.foreignKey.association: '_CCVH'
      @Consumption.valueHelpDefinition: [{ association: '_CompanyCode', label: 'Independent Company Code', qualifier: 'Secondary CC VH' },
                                          { association: '_CCVH', label: 'Payment Subtype Dependent Company Code' } ]
  key CompanyCode,
      @Search: { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 1 }
      @EndUserText.label: 'Accounting Document Number'
  key AccountingDocument,

  key FiscalYear,

      @ObjectModel.foreignKey.association: '_PaymVH'
      @ObjectModel.readOnly: true
      AccountingDocumentType,

      @ObjectModel.mandatory: true
      DocumentDate,

      @ObjectModel.readOnly: true
      PostingDate,
      FiscalPeriod,

      @EndUserText.label: 'Accounting Document Created On'
      AccountingDocumentCreationDate,

      @Consumption.filter.hidden: true
      CreationTime,
      LastChangeDate,
      $session.user                as LoggedinUser,

      @ObjectModel.readOnly
      @EndUserText.label: 'Request Created By'
      @Consumption: { valueHelpDefinition: [{ entity: { name : 'ZC_VH_UserName', element : 'UserID' } }]}
      AccountingDocCreatedByUser,

      @ObjectModel.mandatory: true
      DocumentReferenceID,
      AccountingDocumentHeaderText,

      @Consumption: { valueHelpDefinition: [{ entity: { name : 'I_Currency', element : 'Currency' } }]}
      Currency,
      DocumentItemText,

      @ObjectModel.mandatory: true
      @ObjectModel.text.element:  [ 'VendorName' ]
      @Consumption.valueHelpDefinition: [{ association: '_VendorDetails' }  ]
      Vendor,
      @Semantics.text: true
      @UI.hidden: true
      coalesce(_VendorDetails.VendorName, ' ') as VendorName,

      coalesce(_VendorDetails.VendorUsername, 'None') as VendorUsername,

      @Consumption.filter.hidden: true
      @ObjectModel.mandatory: true
      @Semantics.amount.currencyCode: 'Currency'            
      PaymentAmount, //  Note: This is the Vendor Payment Amount

      @ObjectModel.mandatory: true
      @ObjectModel.text.association: '_PaymTypeKey'
      @ObjectModel.foreignKey.association: '_PaymTypeKey'
      PaymentType,

      @ObjectModel.mandatory: true
      @ObjectModel.text.association: '_PaymSubTypeKey'
      @ObjectModel.foreignKey.association: '_Payment'
      PaymentSubType,

      @EndUserText.label: 'Travel Plan ID'
      @ObjectModel.mandatory: true
      TravelPlanID,

      @EndUserText.label: 'Trip End Date'
      @ObjectModel.mandatory: true
      TripEndDate,

      @EndUserText.label: 'Trip Start Date'
      @ObjectModel.mandatory: true
      TripStartDate,

      @Consumption.filter.hidden: true
      $session.user_date           as BaselineDate,

      @EndUserText.label: 'Approver'
      @ObjectModel.mandatory: true
      @Consumption.valueHelpDefinition: [{ entity : {name:'ZI_FIN_AP_APPROVER_DETAILS_VH' , element: 'Approver' } }]
      @ObjectModel.foreignKey.association: '_ApproverName'
      Approver,
      @EndUserText.label: 'Approver User ID'
      coalesce(_ApproverDetails.UserID, ' ')      as ApproverUserid,
      
      @Consumption.filter.hidden: true
      @UI.hidden: true
      cast('' as sysid )           as L2ApproverUserid,

      AttachmentKey,
      Sensitive,

      //multiple requests can be created we need to add a range of the documents created hence this field only for UI
      cast('' as abap.char( 50 ) ) as DocumentNumber,

      PaymentAdviceNote,
      GrantedFinancialDelegation,

      @Consumption.valueHelpDefinition: [{ entity : {name:'ZI_FIN_CMS_PayTypeFinDeleg_VH' , element: 'FinancialDelegation' },
                                       additionalBinding: [ { localElement: 'PaymentSubType', element: 'PaymentSubType' }  ]   }]
      @ObjectModel.readOnly: true
      FinancialDelegation,

      @Consumption.filter.hidden: true
      @UI.hidden: true
      IsOTV,

      @ObjectModel.text.element: ['ClaimStatusText']
      ClaimStatus,

      @Semantics.text: true
      @EndUserText.label: 'Claim Status Text'
      _StatusText.ClaimStatusText,

      // ******************************* Placeholder for creating line items *******************************
      @Consumption.valueHelpDefinition: [{ entity : {name:'ZI_FIN_CMS_PayTypeGLMap_VH' , element: 'GLAccount' },
        distinctValues: true,
        additionalBinding: [  { localElement: 'CompanyCode', element: 'CompanyCode', usage: #FILTER_AND_RESULT},
                              { localElement: 'PaymentSubType', element: 'PaymentSubType', usage: #FILTER_AND_RESULT}  ] }]
      @ObjectModel.mandatory: true
      GLAccount,
      cast('' as abap.char( 50 ) ) as GLItemText,

      @ObjectModel.foreignKey.association: '_CostCenter'
      CostCenter,

      @EndUserText.label: 'WBS Element'
      @Consumption.valueHelpDefinition: [{ entity : {name:'ZC_VH_WBSElement' , element: 'WBSElementExternalFull' } ,
                     additionalBinding: [{ localElement: 'CompanyCode', element: 'CompanyCode'}]}]
      WBSElement,

      @Consumption.filter.hidden: true
      @UI.hidden: true
      WBSElementInternal,

      @ObjectModel.foreignKey.association: '_InternalOrder'
      OrderNumber,

      @ObjectModel.foreignKey.association: '_TaxVH'
      @ObjectModel.mandatory: true
      TaxCode,

      @UI.hidden
      Currency                     as GLPaymentAmountCurrency,

      @Semantics.amount.currencyCode: 'GLPaymentAmountCurrency'
      @Consumption.filter.hidden: true
      @ObjectModel.mandatory: true
      cast( 0 as wrbtr )           as GLPaymentAmount,

      // ******************************* Associations *******************************
      _Items,
      @Consumption.filter.hidden: true
      _AccountingDocumentType,
      @Consumption.filter.hidden: true
      _CCVH,
      @Consumption.filter.hidden: true
      _CompanyCode,
      @Consumption.filter.hidden: true
      _Currency,
      @Consumption.filter.hidden: true
      _ApproverName,
      @Consumption.filter.hidden: true
      _FiscalYear,
      @Consumption.filter.hidden: true
      _GLVH,
      @Consumption.filter.hidden: true
      _ControlTable,
      @Consumption.filter.hidden: true
      _PaymVH,
      @Consumption.filter.hidden: true
      _TaxVH,
      @Consumption.filter.hidden: true
      _User,
      @Consumption.filter.hidden: true
      _CostCenter,
      @Consumption.filter.hidden: true
      _WBSElement,
      @Consumption.filter.hidden: true
      _InternalOrder,
      @Consumption.filter.hidden: true
      _StatusText,
      @Consumption.filter.hidden: true
      _FinDelVH,
      @Consumption.filter.hidden: true
      _Payment,
      @Consumption.filter.hidden: true
      _PaymTypeKey,
      @Consumption.filter.hidden: true
      _PaymSubTypeKey,
      @Consumption.filter.hidden: true
      _VendorDetails,
      @Consumption.filter.hidden: true
      _UserName
}

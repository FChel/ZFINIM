/*--------------------------------------------------------------------------------------*
* AUTHOR:      010373NK                                                                 *
* DATE:        20/11/2021                                                               *
* WRICEFX-ID:  FINX434  - Employee Reimbursement-AP                                     *
* --------------------------------------------------------------------------------------*
* Purpose: Consumption View for Employee Reimbursement                                  *
* --------------------------------------------------------------------------------------*
* MODIFICATION HISTORY                                                                  *
* UserID       Date        Transport   Description                                      *
* 010373NK     20/11/2021  S2DK907015  Initial development                              *
* 260971JT     04/05/2023  S2DK924126  Add CreatedforName and hide assocs from filter   *
* 240162LV     01/11/2023  S2DK928028  Change of design including Line items            *
* 240162LV     14/12/2023  S2DK929657  Added code to cater for L2 authorisation         *
* 260971JT     07/06/2024  S2DK932748  Add association _ApproverName for Approver name  *
* 260971JT     19/02/2025  S2DK936813  Defect 16719. Expose Created For employee Num    *
* 270982VK     13/06/2025  S23K900178  T3UP ATC Check fix                               *  
*                                      Set CurrencyCode for PaymentAmount Field         * 
* 260971JT     29/10/2025  S2DK940710  Cater for new approval process                   * 
* 020869EB     07/01/2026  S23K902151  T3UP Manual Retrofit S2DK940710                  * 
* 270982VK     22/01/2026  S23K902450  T3UP : Defect 1066 -The annotation               *
*                                      ObjectModel.readOnly                             *   
*                                      of field GLPaymentAmountCurrency is removed      *
*                                      as it is blanking out the GLPayamentAmount value *
*                                      after user input.                                *
* --------------------------------------------------------------------------------------*/
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Employee Reimbursement'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION
@ObjectModel.modelCategory: #BUSINESS_OBJECT
@ObjectModel.compositionRoot: true
@ObjectModel.createEnabled: true
@ObjectModel.updateEnabled: true

define root view entity ZC_FIN_AP_EMPL_REIMBURSEMENT
  as select from ZI_FIN_AP_Empl_Reimburse_VHs
  association [1..1] to I_ParkedGeneralLedgerItem as _GLline on  $projection.CompanyCode        = _GLline.CompanyCode
                                                             and $projection.FiscalYear         = _GLline.FiscalYear
                                                             and $projection.AccountingDocument = _GLline.AccountingDocument
{
      @ObjectModel.text.association: '_CCVH'
      @ObjectModel.foreignKey.association: '_CCVH'
      @Consumption.valueHelpDefinition: [{ association: '_CompanyCode', label: 'Independent Company Code', qualifier: 'Secondary CC VH' },
                                         { association: '_CCVH', label: 'Payment Subtype Dependent Company Code' } ]
      @ObjectModel.text.element: ['CompanyCodeName']
  key CompanyCode,
      @EndUserText.label: 'Accounting Document Number'
  key AccountingDocument,
  key FiscalYear,

      @ObjectModel.text.element: ['AccountingDocumentTypeName']
      AccountingDocumentType,
      DocumentDate,

      @ObjectModel.readOnly: true
      PostingDate,
      FiscalPeriod,

      @EndUserText.label: 'Accounting Document Created On'
      AccountingDocumentCreationDate,

      @Consumption.filter.hidden: true
      CreationTime,
      LastChangeDate,

      @ObjectModel.readOnly
      @EndUserText.label: 'Request Created By'
      @Consumption: { valueHelpDefinition: [{ entity: { name : 'ZC_VH_UserName', element : 'UserID' } }]}
      AccountingDocCreatedByUser,

      @ObjectModel.mandatory: true
      DocumentReferenceID,

      @Consumption.filter.hidden: true
      AccountingDocumentHeaderText,

      @Consumption.filter.hidden: true
      @Consumption: { valueHelpDefinition: [{ entity: { name : 'I_Currency', element : 'Currency' } }]}
      Currency,

      @Consumption.filter.hidden: true
      DocumentItemText,

      Vendor,

      @Consumption.filter.hidden: true
      @ObjectModel.mandatory: true
      @Semantics.amount.currencyCode: 'Currency'
      PaymentAmount,

      @ObjectModel.mandatory: true
      @ObjectModel.text.association: '_PaymTypeKey'
      @ObjectModel.foreignKey.association: '_PaymTypeKey'
      PaymentType,

      @ObjectModel.mandatory: true
      @ObjectModel.text.association: '_PaymSubTypeKey'
      @ObjectModel.foreignKey.association: '_Payment'
      PaymentSubType,
      _PaymVH.PaymentMethod,

      @EndUserText.label: 'Employee Created For'
      @ObjectModel.foreignKey.association: '_CreatedForDetails'
      EmployeeCreatedFor,

      @EndUserText.label: 'Employee Number'
      @ObjectModel.foreignKey.association: '_EmployeeDetails'
      EmployeeNumber,

      isCurrUserCreatedFor,    //Used by DCL

      @EndUserText.label: 'Approver'
      @ObjectModel.mandatory: true
      //@Consumption.valueHelpDefinition: [{ entity : {name:'ZI_FIN_AP_APPROVER_DETAILS_VH' , element: 'Approver' },
      //additionalBinding: [{ localElement: 'EmployeeNumber', element: 'EmployeeNumber'},
      //                    { localElement: 'EmployeeCreatedFor', element: 'CreatedFor'}]  }]
      @ObjectModel.foreignKey.association: '_ApproverName'
      @ObjectModel.readOnly: true
      Approver,
      _ApproverDetails.UserID             as ApproverUserid,
      cast('' as sysid )                  as L2ApproverUserid,

      @EndUserText.label: 'Approver Details'
      @ObjectModel.readOnly: true //JT
      cast('' as char80)                  as ApproverName,

      @EndUserText.label: 'Approver(s) Determined'
      @ObjectModel.readOnly: true //JT
      cast('' as xfeld)                   as ApproverDetermined,

      @Consumption.filter.hidden: true
      @ObjectModel.readOnly: true
      _EmployeeBankDetails.BSB,

      @Consumption.filter.hidden: true
      @ObjectModel.readOnly: true
      _EmployeeBankDetails.BankAccountNumber,

      @Consumption.filter.hidden: true
      @ObjectModel.readOnly: true
      _EmployeeBankDetails.BankName,

      cast('' as abap.char( 50 ) )        as DocumentNumber, //For UI only
      cast('' as abap.char( 10 ) )        as DraftRequestNumber,

      @Semantics.text: true
      @EndUserText.label: 'Claim Status Text'
      _StatusText.ClaimStatusText,

      PaymentAdviceNote,
      AttachmentKey,

      @Consumption.filter.hidden: true
      GrantedFinancialDelegation,

      FinancialDelegation,
      Sensitive,

      @ObjectModel.mandatory: true
      @ObjectModel.foreignKey.association: '_StudyPeriod'
      StudyPeriod,
      @Semantics.text
      AccountingDocumentTypeName,

      // ******************************* Admin fields *******************************
      @ObjectModel.readOnly
      BulkUploadText,

      @ObjectModel.text.element: ['ClaimStatusText']
      ClaimStatus,

      cast('X' as xfeld preserving type ) as Draft,
      cast('X' as xfeld preserving type)  as Editable,

      @Consumption.filter.hidden: true
      IsSubmitted,
      @Consumption.filter.hidden: true
      IsDraft,

      @Consumption.filter.hidden: true
      //Recallable if status is Submitted or Return to Work and user is the created by or created for
      // BUT never for bulk upload records
      case
      when BulkUploadText = 'Yes' then
            cast( ' ' as boolean preserving type )

      when IsSubmitted = 'X' then
         case UserCurrent
         when UserCreatedBy then   cast( 'X' as boolean preserving type )
         when UserCreatedFor then  cast( 'X' as boolean preserving type )
         else                      cast( ' ' as boolean preserving type )
         end

      when IsReturnToRework = 'X' then
          case UserCurrent
            when UserCreatedBy then  cast( 'X' as boolean preserving type )
            when UserCreatedFor then cast( 'X' as boolean preserving type )
            else                     cast( ' ' as boolean preserving type )
           end
      else
         cast( ' ' as boolean preserving type )

      end                                 as IsRecallable,

      @Consumption.filter.hidden: true
      NoApproverRequiredForUIInd,

      // Required for Access Control Check
      @Consumption.filter.hidden: true
      case  NoApproverRequiredForUIInd                                                // Single approver has not been supplied, the approver position is defaulted through config
      // Special processing on approver per position - not approver on front end
        when 'X'  then case _PaySubApproversPos.PaymentSubType
                        when PaymentSubType then 'X'
                        else ' '
                        end
      // Default Valid Approver
        else 'X'
      end                                 as ValidApprover,

      @Consumption.filter.hidden: true
      IsEscalated,

      @Consumption.filter.hidden: true
      case when IsEscalated = 'X'
           then case when NoApproverRequiredForUIInd = 'X'    // mapped approver position
                     then case when _ApproverPosManager.OrgUnit1UpLeadPosition is not null
                               then 'X'
                               else ' '
                           end   
                     else case when _LineManager.OrgUnit1UpLeadPosition is not null    // Single approver
                               then 'X'
                               else ' '
                          end
                 end
           else ''  // not escalated
      end                                 as ValidEscalationApprover,

      // ******************************* Placeholder for creating line items *******************************
      @Consumption.valueHelpDefinition: [{ entity : {name:'ZC_FIN_REIM_PAYTYPEGLMAP_VH' , element: 'GLAccount' },
      distinctValues: true,
      additionalBinding: [  { localElement: 'CompanyCode', element: 'CompanyCode', usage: #FILTER_AND_RESULT},
                            { localElement: 'PaymentType', element: 'PaymentType', usage: #FILTER_AND_RESULT},
                            { localElement: 'PaymentSubType', element: 'PaymentSubType', usage: #FILTER_AND_RESULT}  ] }]
      @ObjectModel.text.element: ['GLAccountText']
      @ObjectModel.mandatory: true
      GLAccount,

      cast('' as abap.char( 50 ) )        as GLItemText,
      @ObjectModel.foreignKey.association: '_CostCenter'
      CostCenter,

      @EndUserText.label: 'WBS Element'
      @Consumption.valueHelpDefinition: [{ entity : {name:'ZC_VH_WBSElement' , element: 'WBSElementExternalFull' },
                     additionalBinding: [{ localElement: 'CompanyCode', element: 'CompanyCode'}]}]
      WBSElement,

      @Consumption.filter.hidden: true
      WBSElementInternal,

      @ObjectModel.foreignKey.association: '_InternalOrder'
      OrderNumber,

      @ObjectModel.foreignKey.association: '_TaxVH'
      @ObjectModel.mandatory: true
      @Consumption.valueHelp: '_TaxVH'
      TaxCode,

      @UI.hidden
      Currency                            as GLPaymentAmountCurrency,

      @Semantics.amount.currencyCode: 'GLPaymentAmountCurrency'
      @Consumption.filter.hidden: true
      @ObjectModel.mandatory: true
      cast( 0 as wrbtr )                  as GLPaymentAmount,

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
      _FiscalYear,
      @Consumption.filter.hidden: true
      _GLVH,
      @Consumption.filter.hidden: true
      _EmployeeBankDetails,
      @Consumption.filter.hidden: true
      _PaymVH,
      @Consumption.filter.hidden: true
      _TaxVH,
      @Consumption.filter.hidden: true
      _User,
      @Consumption.filter.hidden: true
      _Payment,
      _EmployeeDetails,
      @Consumption.filter.hidden: true
      _ApproverDetails,
      @Consumption.filter.hidden: true
      _ApproverName,
      @Consumption.filter.hidden: true
      _CreatedForDetails,
      @Consumption.filter.hidden: true
      _CostCenter,
      @Consumption.filter.hidden: true
      _WBSElement,
      @Consumption.filter.hidden: true
      _InternalOrder,
      @Consumption.filter.hidden: true
      _StatusText,
      @Consumption.filter.hidden: true
      _PaymTypeKey,
      @Consumption.filter.hidden: true
      _PaymSubTypeKey,
      @Consumption.filter.hidden: true
      _GLline,
      @Consumption.filter.hidden: true
      _StudyPeriod,
      _AccountingDocumentTypeText
}

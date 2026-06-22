// AUTHOR:      KRNAX001
// DATE:        25 Jun 2021
// WRICEFX-ID:  FINX303
// ---------------------------------------------------------
// Purpose: Consumption View for Invoice Header
// ---------------------------------------------------------
// ---------------------------------------------------------
// MODIFICATION HISTORY                                     
// UserID       Date        Transport   Description         
// KRNAX001     25 Jun 2021  S42K900700  Initial development
// 010373NK     15 Feb 2022  S2DK910956  FUT Fixes
// 260971JT     14 Sept 2023 S2DK927323  Remove "Defence Group" VH
// ----------------------------------------------------------------
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Invoice Header'
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZC_FIN_ACCRECINVOICEHEADER
  as select from ZI_FIN_ACCRECINVOICEHEADER
{

  key InvoiceKey,
      @ObjectModel.text.element: ['CompanyCodeText']
      @Search.defaultSearchElement: true
      CompanyCode,
      @Semantics.text: true
      CompanyCodeText,
      FiscalYear,
      RequestNumber,
      @Consumption.valueHelpDefinition: [{ entity : {name:'ZC_VH_DocType' , element: 'DocType' }}]
      @ObjectModel.text.element: ['DocumentText']
      DocumentType,
      @Semantics.text: true
      DocumentText,
      Currency,
      CustomerNumber,
      ReferenceDocumentNumber,
      @ObjectModel.text.element: ['HeaderText']
      @Search.defaultSearchElement: true
      HeaderText,
      ReasonCode,
      DebtorPoc,
      OverviewOfDebt,
      DetailsOfDebt,
      EmployeeId,
      RequesterName,
      @Semantics.dateTime: true
      RequestDate,
      //@Consumption.valueHelpDefinition: [{ entity : {name:'ZC_VH_Defencegrp' , element: 'Defgroup' }}]
      @ObjectModel.text.element: ['DefenceGroup']
      @Search.defaultSearchElement: true
      DefenceGroup,
      Division,
      Branch,
      TotalPrice,
      TotalTaxAmount,
      TotalNetAmount,
      DebtorContactDetails,
      DebtorContacted,
      PhoneNo,
      EmailAddress,
      @ObjectModel.text.element: ['RequestStatusText']
      @Search.defaultSearchElement: true
      RequestStatus,
      @Semantics.text: true
      RequestStatusText,
      SubmitSelected,
      ApproveSelected,
      RejectSelected,
      RejectionComments,
      //CreatedBy,
      CreatedDate,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _CCVH,
      _Currency,
      _CustomerText,
      _DocType,
      _EmployeeVH,
      _InvItem,
      _RequestStatusText,
      _ReasonCodeVH


}

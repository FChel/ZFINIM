// AUTHOR:      KRNAX001
// DATE:        25 Jun 2021
// WRICEFX-ID:  FINX303
// ---------------------------------------------------------
// Purpose: Consumption View for ZI_FIN_ACCRECINVOICEITEM
// ---------------------------------------------------------
// ---------------------------------------------------------
// MODIFICATION HISTORY                                     //
// UserID       Date        Transport   Description         //
// KRNAX001     25 Jun 2021  S42K900700  Initial development
// ---------------------------------------------------------
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Invoice Item Details'
define view entity ZC_FIN_ACCRECINVOICEITEM
  as select from ZI_FIN_ACCRECINVOICEITEM
{

  key InvoiceKey,
  key Invitemkey,
      CompanyCode,
      InvoiceItemNumber,
      GlAccountNumber,
      ItemText,
      Quantity,
      UnitOfMeasure,
      NetPrice,
      TaxCode,
      GrossAmount,
      CostCenter,
      WbsElement,
      Currency,
      
      OrderNumber,
      //CreatedBy,
      CreatedDate,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _CostCenter,
      _Currency,
      _InternalOrder,
      _InvHeader,
//      _TaxCode,
      _UnitofMeasure,
      _WBSElement
}

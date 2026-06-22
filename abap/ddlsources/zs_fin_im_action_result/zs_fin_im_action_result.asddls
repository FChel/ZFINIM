@EndUserText.label: 'VIM GR Action Result'
define abstract entity ZS_FIN_IM_ACTION_RESULT
{
  VimDocumentId : /opt/docid;
  Success       : abap_boolean;
  MessageText   : abap.string(0);
}

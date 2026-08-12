@AbapCatalog.sqlViewName: 'ZCRAPGITEMP'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Git Demo: Employee (Projection)'
@Metadata.allowExtensions: true
@Search.searchable: true
@UI.headerInfo: {
  typeName: 'Employee',
  typeNamePlural: 'Employees',
  title: { type: #STANDARD, value: 'LastName' }
}
define root view entity ZC_RAP_GIT_EMP
  provider contract transactional_query
  as projection on ZI_RAP_GIT_EMP as Employee
{
      @UI.facet: [ { id: 'Employee', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE, label: 'Employee', position: 10 } ]
      @UI.identification: [ { position: 10 } ]
      @UI.lineItem: [ { position: 10 } ]
  key EmployeeId,

      @UI.identification: [ { position: 20 } ]
      @UI.lineItem: [ { position: 20 } ]
      @UI.selectionField: [ { position: 10 } ]
      @Search.defaultSearchElement: true
      FirstName,

      @UI.identification: [ { position: 30 } ]
      @UI.lineItem: [ { position: 30 } ]
      @UI.selectionField: [ { position: 20 } ]
      @Search.defaultSearchElement: true
      LastName,

      @UI.identification: [ { position: 40 } ]
      @UI.lineItem: [ { position: 40 } ]
      @UI.selectionField: [ { position: 30 } ]
      Department,

      @UI.identification: [ { position: 50 } ]
      @UI.lineItem: [ { position: 50 } ]
      Email,

      @UI.identification: [ { position: 60 } ]
      @UI.lineItem: [ { position: 60, importance: #LOW } ]
      CreatedBy,

      @UI.identification: [ { position: 70 } ]
      @UI.lineItem: [ { position: 70, importance: #LOW } ]
      CreatedAt,

      @UI.identification: [ { position: 80 } ]
      @UI.lineItem: [ { position: 80, importance: #LOW } ]
      LastChangedBy,

      @UI.identification: [ { position: 90 } ]
      @UI.lineItem: [ { position: 90, importance: #LOW } ]
      LastChangedAt
}

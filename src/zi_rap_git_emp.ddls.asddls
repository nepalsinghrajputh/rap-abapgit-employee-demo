@AbapCatalog.sqlViewName: 'ZIRAPGITEMP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Git Demo: Employee (Interface)'
@Metadata.allowExtensions: true
define root view entity ZI_RAP_GIT_EMP
  as select from zrap_git_emp
{
  key employee_id                                as EmployeeId,
      first_name                                  as FirstName,
      last_name                                    as LastName,
      department                                    as Department,
      email                                          as Email,

      @Semantics.user.createdBy: true
      created_by                                      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                      as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      changed_by                                      as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at                                      as LastChangedAt
}

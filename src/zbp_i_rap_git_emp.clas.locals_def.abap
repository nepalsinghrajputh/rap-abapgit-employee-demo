CLASS lhc_Employee DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setEmployeeId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Employee~setEmployeeId.

    METHODS setCreatedAdminData FOR DETERMINE ON SAVE
      IMPORTING keys FOR Employee~setCreatedAdminData.

    METHODS setChangedAdminData FOR DETERMINE ON SAVE
      IMPORTING keys FOR Employee~setChangedAdminData.

    METHODS validateEmployee FOR VALIDATE ON SAVE
      IMPORTING keys FOR Employee~validateEmployee.

ENDCLASS.

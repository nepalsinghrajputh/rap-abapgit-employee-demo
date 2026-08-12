CLASS lhc_Employee IMPLEMENTATION.

  METHOD setEmployeeId.

    " Simplified sequential numbering for demonstration purposes only.
    " Not concurrency-safe; use a number range object for productive use.
    DATA max_id TYPE zrap_git_emp-employee_id.

    SELECT SINGLE MAX( employee_id ) FROM zrap_git_emp INTO @max_id.

    MODIFY ENTITIES OF zi_rap_git_emp IN LOCAL MODE
      ENTITY Employee
      UPDATE FIELDS ( EmployeeId )
      WITH VALUE #( FOR key IN keys INDEX INTO i (
                       %tky       = key-%tky
                       EmployeeId = max_id + i ) ).

  ENDMETHOD.

  METHOD setCreatedAdminData.

    MODIFY ENTITIES OF zi_rap_git_emp IN LOCAL MODE
      ENTITY Employee
      UPDATE FIELDS ( CreatedAt CreatedBy )
      WITH VALUE #( FOR key IN keys (
                       %tky      = key-%tky
                       CreatedAt = utclong_current( )
                       CreatedBy = cl_abap_context_info=>get_user_technical_name( ) ) ).

  ENDMETHOD.

  METHOD setChangedAdminData.

    MODIFY ENTITIES OF zi_rap_git_emp IN LOCAL MODE
      ENTITY Employee
      UPDATE FIELDS ( LastChangedAt LastChangedBy )
      WITH VALUE #( FOR key IN keys (
                       %tky          = key-%tky
                       LastChangedAt = utclong_current( )
                       LastChangedBy = cl_abap_context_info=>get_user_technical_name( ) ) ).

  ENDMETHOD.

  METHOD validateEmployee.

    READ ENTITIES OF zi_rap_git_emp IN LOCAL MODE
      ENTITY Employee
      FIELDS ( FirstName LastName Department Email )
      WITH CORRESPONDING #( keys )
      RESULT DATA(employees).

    LOOP AT employees INTO DATA(employee).

      APPEND VALUE #( %tky = employee-%tky ) TO reported-employee.

      IF employee-FirstName IS INITIAL.
        APPEND VALUE #( %tky        = employee-%tky
                         %state_area = 'VALIDATE_EMPLOYEE' ) TO failed-employee.
        APPEND VALUE #( %tky               = employee-%tky
                         %state_area        = 'VALIDATE_EMPLOYEE'
                         %element-FirstName = if_abap_behv=>mk-on
                         %msg = new_message_with_text(
                                    severity = if_abap_behv_message=>severity-error
                                    text     = 'First Name must not be empty.' ) )
               TO reported-employee.
      ENDIF.

      IF employee-LastName IS INITIAL.
        APPEND VALUE #( %tky        = employee-%tky
                         %state_area = 'VALIDATE_EMPLOYEE' ) TO failed-employee.
        APPEND VALUE #( %tky              = employee-%tky
                         %state_area       = 'VALIDATE_EMPLOYEE'
                         %element-LastName = if_abap_behv=>mk-on
                         %msg = new_message_with_text(
                                    severity = if_abap_behv_message=>severity-error
                                    text     = 'Last Name must not be empty.' ) )
               TO reported-employee.
      ENDIF.

      IF employee-Department IS INITIAL.
        APPEND VALUE #( %tky        = employee-%tky
                         %state_area = 'VALIDATE_EMPLOYEE' ) TO failed-employee.
        APPEND VALUE #( %tky                = employee-%tky
                         %state_area         = 'VALIDATE_EMPLOYEE'
                         %element-Department = if_abap_behv=>mk-on
                         %msg = new_message_with_text(
                                    severity = if_abap_behv_message=>severity-error
                                    text     = 'Department must not be empty.' ) )
               TO reported-employee.
      ENDIF.

      IF employee-Email IS INITIAL.
        APPEND VALUE #( %tky        = employee-%tky
                         %state_area = 'VALIDATE_EMPLOYEE' ) TO failed-employee.
        APPEND VALUE #( %tky           = employee-%tky
                         %state_area    = 'VALIDATE_EMPLOYEE'
                         %element-Email = if_abap_behv=>mk-on
                         %msg = new_message_with_text(
                                    severity = if_abap_behv_message=>severity-error
                                    text     = 'Email must not be empty.' ) )
               TO reported-employee.
      ELSEIF employee-Email NP '*@*.*'.
        APPEND VALUE #( %tky        = employee-%tky
                         %state_area = 'VALIDATE_EMPLOYEE' ) TO failed-employee.
        APPEND VALUE #( %tky           = employee-%tky
                         %state_area    = 'VALIDATE_EMPLOYEE'
                         %element-Email = if_abap_behv=>mk-on
                         %msg = new_message_with_text(
                                    severity = if_abap_behv_message=>severity-error
                                    text     = 'Email address format is invalid.' ) )
               TO reported-employee.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

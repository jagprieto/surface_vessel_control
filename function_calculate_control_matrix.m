function CONTROL_MATRIX = function_calculate_control_matrix(ROTATION_MATRIX, INERTIA_MATRIX_INVERSE)
%     disp('*******************eeeeeeeee*******************');
%     ROTATION_MATRIX
%     INERTIA_MATRIX_INVERSE
    CONTROL_MATRIX = ROTATION_MATRIX*INERTIA_MATRIX_INVERSE;
%     disp('**************************************');
end
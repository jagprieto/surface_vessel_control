function ROTATION_MATRIX = function_calculate_rotation_matrix(yaw)
    ROTATION_MATRIX = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
end
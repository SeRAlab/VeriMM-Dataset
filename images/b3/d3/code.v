module top_module(
    input Add_Subt_i,
    input sgn_X_i,
    input sgn_Y_i,
    input gtXY_i,
    input eqXY_i,
    output sgn_result_o
);// Declaration of LUT5 equivalent function with a case statement
assign sgn_result_o = (eqXY_i) ? sgn_Y_i :
                      (Add_Subt_i) ? (sgn_X_i ^ gtXY_i) :
                      (gtXY_i) ? sgn_X_i :
                      (sgn_Y_i);

endmodule
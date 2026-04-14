module top_module(
    input wire Add_Subt_i, 
    input wire sgn_X_i, 
    input wire sgn_Y_i, 
    input wire gtXY_i, 
    input wire eqXY_i, 
    output wire sgn_result_o 
    );assign sgn_result_o = (gtXY_i | ((Add_Subt_i | sgn_Y_i) & (~Add_Subt_i | ~sgn_Y_i))) & ( sgn_X_i | ~(eqXY_i | gtXY_i));
endmodule
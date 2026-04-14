module top_module(
    input wire Op_A_i,
    input wire Op_B_i,
    input wire C_i, 
    output wire C_o, 
    output wire P_o 
    );assign P_o = Op_A_i ^ Op_B_i;
    assign C_o = (Op_A_i & Op_B_i) | (P_o & C_i);
    
    
endmodule
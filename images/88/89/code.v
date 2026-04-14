module top_module(
    input wire Op_A_i,
    input wire Op_B_i,
    input wire C_i, 
    output wire S_o, 
    output wire C_o, 
    output wire P_o 
    );wire G_o;
    assign P_o = Op_A_i ^ Op_B_i;
    assign G_o = Op_A_i & Op_B_i;
    assign S_o = P_o ^ C_i;
    assign C_o = G_o | (P_o & C_i);
    
endmodule
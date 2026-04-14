module top_module(reg_out_ex, reg_in_ex, Sel2);input [2:0]reg_out_ex, reg_in_ex;
output Sel2;
assign Sel2 = (reg_out_ex == reg_in_ex)? (1):(0);
endmodule
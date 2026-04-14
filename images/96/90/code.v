module top_module(input sel_i,input [1:0] dat_i,output dat_o);assign dat_o = sel_i && dat_i[1] || ~sel_i && dat_i[0]; 
 endmodule
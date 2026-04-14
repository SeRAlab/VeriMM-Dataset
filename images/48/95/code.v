module top_module(input [2:0] v,output [2:0] result);assign result[2]=v[2]&v[1];
assign result[1]=(~v[1])&v[2];
assign result[0]=v[0];
endmodule
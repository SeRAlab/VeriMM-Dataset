module top_module(offset,pc, result);input [31:0] pc;
input [31:0] offset;
output [31:0] result;

wire dum;
wire useless_inputs;
assign useless_inputs = |offset;
assign {dum,result} = pc + {offset[31:0],2'b0};

endmodule
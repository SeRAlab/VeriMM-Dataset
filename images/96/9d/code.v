module top_module(input wire bit c_i, input wire bit[1:0] a, b,
	    output wire bit [1:0] out, output wire bit c_o);assign {c_o, out} = {1'b0, a} + {1'b0, b} + {2'b00, c_i};

endmodule
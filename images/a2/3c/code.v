module top_module(
    input [2:0] v_in,
    output [2:0] v_out
    );assign v_out[0] = (v_in[2] & v_in[0]) | (v_in[1] & v_in[0]); 
	assign v_out[1] = (v_in[2] & ~v_in[1]);
	assign v_out[2] = (v_in[2] & v_in[1]);

endmodule
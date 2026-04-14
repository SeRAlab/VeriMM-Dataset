module top_module (
        input in,
        input [3:0] state,
        output reg [3:0] next_state,
        output reg out1,
        output reg out2);assign out1 = state[1] | state[3];
	assign out2 = state[2] | state[3];

	assign next_state[0] = in && state[2];
	assign next_state[1] = !in && (state[0] | state[3]);
	assign next_state[2] = in && (state[0] | state[3]);
	assign next_state[3] = !in && (state[1] | state[2]);

endmodule
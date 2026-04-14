module top_module (
        input in,
        input [2:0] state,
        output reg [2:0] next_state,
        output reg out);assign out = state[2];

	assign next_state[0] = !in && (state[0] | state[1] | state[2]);
	assign next_state[1] = in && (state[0] | state[2]);
	assign next_state[2] = in && (state[1] | state[0]);

endmodule
module top_module (
        input in,
        input [1:0] state,
        output reg [1:0] next_state,
        output reg out);assign out = state[1];

	assign next_state[0] = in && state[1] || !in && state[0];
	assign next_state[1] = in && state[0] || !in && state[1];

endmodule
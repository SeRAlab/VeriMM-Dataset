module top_module (
        input in1,
        input in2,
        input [3:0] state,
        output reg [3:0] next_state,
        output reg out);assign out = state[1] || state[3];

	assign next_state[0] = !in1 && !in2 && state[3] || in1 && in2 && state[2];
	assign next_state[1] = !in1 && !in2 && state[0] || in1 && in2 && state[3];
	assign next_state[2] = !in1 && !in2 && state[1] || in1 && in2 && state[0];
	assign next_state[3] = !in1 && !in2 && state[2] || in1 && in2 && state[1];

endmodule
module top_module (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out1,
    output reg out2,
    output reg out3,
    output reg out4);

assign out1 = state[0];
assign out2 = state[1];
assign out3 = state[2];
assign out4 = state[3];

assign next_state[0] = !in && state[3] || in && state[2];
assign next_state[1] = !in && state[0] || in && state[3];
assign next_state[2] = !in && state[1] || in && state[0];
assign next_state[3] = !in && state[2] || in && state[1];

endmodule
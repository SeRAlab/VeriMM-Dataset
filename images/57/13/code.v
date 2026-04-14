module top_module (
    input clk,
    input reset,
    input in,
    output reg [1:0] state);typedef enum reg [1:0] {S0, S1, S2} states;
states current_state, next_state;

always @(posedge clk or posedge reset)
    if (reset)
        current_state <= S0;
    else
        current_state <= next_state;

always @(*)
    case (current_state)
        S0: next_state = in ? S1 : S0;
        S1: next_state = in ? S2 : S0;
        S2: next_state = in ? S2 : S0;
        default: next_state = S0;
    endcase

assign state = current_state;

endmodule
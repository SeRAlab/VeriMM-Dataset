module state_space_controller (
    input clk,
    input [3:0] current_state,
    output reg [3:0] next_state
);

always @(posedge clk) begin
    case (current_state)
        4'b0000: next_state <= 4'b0001; // State 00 -> State 01
        4'b0001: next_state <= 4'b0010; // State 01 -> State 10
        4'b0010: next_state <= 4'b0011; // State 10 -> State 11
        4'b0011: next_state <= 4'b0000; // State 11 -> State 00
        default: next_state <= 4'b0000; // Default to State 00
    endcase
end

endmodule
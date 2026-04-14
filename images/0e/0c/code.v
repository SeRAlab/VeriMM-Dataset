module state_space_controller (
    input clk,
    input rst,
    input control,
    input [2:0] current_state,
    output reg [2:0] next_state
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        next_state <= 3'b000; // reset to state 0
    end else begin
        case (current_state)
            3'b000: next_state <= (control) ? 3'b001 : 3'b000; // state 0
            3'b001: next_state <= (control) ? 3'b001 : 3'b010; // state 1
            3'b010: next_state <= (control) ? 3'b010 : 3'b000; // state 2
            default: next_state <= 3'b000; // default to state 0
        endcase
    end
end

endmodule
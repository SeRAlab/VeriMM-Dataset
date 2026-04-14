module state_space_controller (
    input clk,
    input rst,
    input [1:0] current_state,
    output reg [1:0] next_state
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_state <= 2'b00; // Reset to state 00
        end else begin
            case (current_state)
                2'b00: next_state <= 2'b01;
                2'b01: next_state <= 2'b10;
                2'b10: next_state <= 2'b11;
                2'b11: next_state <= 2'b00;
                default: next_state <= 2'b00; // Default to reset state
            endcase
        end
    end
endmodule
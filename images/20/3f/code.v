module state_space_controller (
    input clk,
    input rst,
    input [3:0] current_state,
    input control_input,
    output reg [3:0] next_state
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        next_state <= 4'b0000; // Reset to state 0
    end else begin
        case (current_state)
            4'b0000: next_state <= (control_input) ? 4'b0010 : 4'b0001;
            4'b0001: next_state <= (control_input) ? 4'b0100 : 4'b0011;
            4'b0010: next_state <= (control_input) ? 4'b0000 : 4'b0101;
            4'b0011: next_state <= (control_input) ? 4'b0000 : 4'b0110;
            4'b0100: next_state <= (control_input) ? 4'b0111 : 4'b0101;
            4'b0101: next_state <= (control_input) ? 4'b0001 : 4'b0000;
            4'b0110: next_state <= (control_input) ? 4'b0011 : 4'b0111;
            4'b0111: next_state <= (control_input) ? 4'b0100 : 4'b0000;
            default: next_state <= 4'b0000; // Default case
        endcase
    end
end

endmodule
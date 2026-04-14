module mpc_fsm (
    input clk,
    input reset,
    input [3:0] current_state,
    input [1:0] control_input,
    output reg [3:0] next_state
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        next_state <= 4'b0000; // Initial state
    end else begin
        case (current_state)
            4'b0000: next_state <= (control_input == 2'b00) ? 4'b0001 : 4'b0010;
            4'b0001: next_state <= (control_input == 2'b00) ? 4'b0011 : 4'b0100;
            4'b0010: next_state <= (control_input == 2'b01) ? 4'b0101 : 4'b0000;
            4'b0011: next_state <= (control_input == 2'b01) ? 4'b0000 : 4'b0010;
            // Additional state transitions can be defined here
            default: next_state <= 4'b0000; // Default case
        endcase
    end
end
endmodule
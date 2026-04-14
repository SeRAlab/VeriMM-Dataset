module mpc_controller (
    input clk,
    input rst,
    input [1:0] control_signal,
    input [2:0] state_input,
    output reg [2:0] state_output
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_output <= 3'b000; // Reset state
        end else begin
            case (control_signal)
                2'b00: state_output <= state_input; // No transition
                2'b01: state_output <= state_input + 1; // Transition 1
                2'b10: state_output <= state_input + 2; // Transition 2
                2'b11: state_output <= state_input + 3; // Transition 3
                default: state_output <= 3'b000; // Default case
            endcase
        end
    end
endmodule
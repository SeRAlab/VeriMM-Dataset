module deadbeat_controller (
    input clk,
    input reset,
    input [2:0] state,
    output reg control_signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 0;
        end else begin
            case (state)
                3'b000: control_signal <= 1; // Transition from state 0 to 1
                3'b001: control_signal <= 1; // Transition from state 1 to 2
                3'b010: control_signal <= 1; // Transition from state 2 to 3
                3'b011: control_signal <= 0; // Final state
                3'b100: control_signal <= 0; // No action
                default: control_signal <= 0; // Default case
            endcase
        end
    end
endmodule
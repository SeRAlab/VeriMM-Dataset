module mpc_controller (
    input clk,
    input [3:0] current_state,
    input [3:0] desired_state,
    output reg [3:0] control_signal
);
    always @(posedge clk) begin
        if (current_state < desired_state) begin
            control_signal <= current_state + 1; // Increment towards desired state
        end else if (current_state > desired_state) begin
            control_signal <= current_state - 1; // Decrement towards desired state
        end else begin
            control_signal <= current_state; // No change if states are equal
        end
    end
endmodule
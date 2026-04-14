module mpc_controller(
    input clk,
    input reset,
    input enable,
    input [7:0] current_state,
    input [7:0] reference_state,
    input [7:0] control_signal,
    output reg [7:0] next_state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_state <= 8'b0;
        end else if (enable) begin
            // Simple control law: next state is current state plus some control adjustment
            // For demonstration, we assume a simple proportional control
            next_state <= current_state + (reference_state - current_state) / 2 + control_signal;
        end else begin
            next_state <= current_state; // Hold current state
        end
    end
endmodule
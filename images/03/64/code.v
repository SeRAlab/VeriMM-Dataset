module mpc_controller (
    input [3:0] control_input,
    input [3:0] state_input,
    input clk,
    input reset,
    output reg [3:0] control_signal
);
    parameter [3:0] COEFFICIENT = 4'b0011; // Example coefficient
    parameter [3:0] BIAS = 4'b0001; // Example bias

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 4'b0000; // Reset control signal
        end else begin
            control_signal <= (state_input * COEFFICIENT) + BIAS; // Compute control signal
        end
    end
endmodule
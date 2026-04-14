module mpc_controller(
    input clk,
    input reset,
    input [7:0] current_state,
    input [7:0] reference_state,
    output reg [7:0] control_signal
);
    // Gain for the control signal
    parameter GAIN = 8'd2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 8'd0;
        end else begin
            control_signal <= (reference_state - current_state) * GAIN;
        end
    end
endmodule
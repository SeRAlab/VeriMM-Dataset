module mpc_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] state,       // Current state
    input wire [7:0] reference,   // Reference signal
    output reg [7:0] control_out   // Control output
);

    parameter PROPORTIONAL_GAIN = 8; // Proportional gain for control

    reg [7:0] previous_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_out <= 8'b0;
            previous_state <= 8'b0;
        end else begin
            control_out <= (reference - state) * PROPORTIONAL_GAIN;
            previous_state <= state;
        end
    end
endmodule
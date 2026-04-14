module mpc_controller(
    input clk,
    input reset,
    input [7:0] input_signal,
    output reg [7:0] control_output
);
    reg [7:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b0;
            control_output <= 8'b0;
        end else begin
            state <= input_signal + state; // Update state based on input
            control_output <= 2 * state;    // Simple control output logic
        end
    end
endmodule
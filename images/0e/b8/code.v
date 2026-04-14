module phase_shifter (
    input wire clk,
    input wire [3:0] phase_ctrl,
    input wire [3:0] input_signal,
    output reg [3:0] output_signal
);
    always @(posedge clk) begin
        output_signal <= input_signal << phase_ctrl; // Shift left by phase control value
    end
endmodule
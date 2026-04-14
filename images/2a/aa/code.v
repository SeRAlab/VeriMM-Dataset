module echo_cancellation (
    input wire clk,
    input wire rst,
    input wire [15:0] input_signal,
    input wire [15:0] reference_signal,
    input wire [3:0] delay,
    output reg [15:0] output_signal
);
    reg [15:0] delayed_signal [0:15]; // Delay line for reference signal
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset delayed signal
            for (i = 0; i < 16; i = i + 1) begin
                delayed_signal[i] <= 16'b0;
            end
            output_signal <= 16'b0;
        end else begin
            // Shift the delayed signals
            for (i = 15; i > 0; i = i - 1) begin
                delayed_signal[i] <= delayed_signal[i - 1];
            end
            // Update the newest delayed signal
            delayed_signal[0] <= reference_signal;

            // Generate output signal with the specified delay
            output_signal <= input_signal - delayed_signal[delay];
        end
    end
endmodule
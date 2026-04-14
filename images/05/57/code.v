module echo_canceller (
    input wire clk,
    input wire [15:0] input_signal,
    input wire [15:0] echo_signal,
    output reg [15:0] output_signal
);
    reg [15:0] error_signal;

    always @(posedge clk) begin
        error_signal <= input_signal - echo_signal; // Calculate error
        output_signal <= input_signal - (error_signal >>> 1); // Simple cancellation
    end
endmodule
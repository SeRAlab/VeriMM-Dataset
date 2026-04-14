module EchoCancellation(
    input wire clk,
    input wire [15:0] input_signal,
    input wire [15:0] echo_signal,
    output reg [15:0] output_signal
);
    always @(posedge clk) begin
        output_signal <= input_signal - echo_signal;
    end
endmodule
module echo_cancellation(
    input wire clk,
    input wire reset,
    input wire [15:0] input_signal,
    input wire [15:0] echo_signal,
    output reg [15:0] output_signal
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 16'b0;
        end else begin
            output_signal <= input_signal - echo_signal;
        end
    end
endmodule
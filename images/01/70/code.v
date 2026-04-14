module echo_cancellation (
    input clk,
    input rst,
    input signed [15:0] input_signal,
    input signed [15:0] echo_signal,
    output reg signed [15:0] output_signal
);
    
    reg signed [15:0] last_output;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_signal <= 16'b0;
            last_output <= 16'b0;
        end else begin
            output_signal <= input_signal - echo_signal;
            last_output <= output_signal;
        end
    end
endmodule
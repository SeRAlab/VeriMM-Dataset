module iir_filter (
    input clk,
    input rst,
    input signed [15:0] input_sample,
    output reg signed [15:0] output_sample
);
    parameter signed [15:0] a = 16'h1000; // Example coefficient a = 1.0 in fixed-point
    parameter signed [15:0] b = 16'h0800; // Example coefficient b = 0.5 in fixed-point

    reg signed [15:0] prev_output;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_sample <= 16'b0;
            prev_output <= 16'b0;
        end else begin
            output_sample <= (prev_output * a >>> 12) + (input_sample * b >>> 12);
            prev_output <= output_sample;
        end
    end
endmodule
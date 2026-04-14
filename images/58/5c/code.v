module top_module(
    input clk,
    input slowena,
    input reset,
    input [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo,
    output reg [3:0] q,
    output reg [7:0] sum
);// Byte Splitter
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

    // Decade Counter
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            q <= 0;
        end else if (slowena == 1) begin
            if (q == 9) begin
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end

    // Additive Functional Module
    always @(out_hi, out_lo) begin
        sum = out_hi + out_lo;
    end

endmodule
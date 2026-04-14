module top_module(
    input clk,
    input reset,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] a, b, c, d,
    output [15:0] out,
    output [7:0] out_lo,
    output [7:0] final_out
);// Multiplication module
    reg [15:0] mult_result;
    reg [7:0] mult_lo;
    reg [3:0] i;
    always @ (posedge clk) begin
        if (reset) begin
            mult_result <= 16'b0;
            mult_lo <= 8'b0;
            i <= 4'b0;
        end else begin
            mult_result <= {8'b0, in1} * {8'b0, in2};
            for (i = 0; i < 8; i = i + 1) begin
                mult_result <= mult_result + (mult_lo << 8);
                mult_lo <= mult_result[7:0];
            end
        end
    end
    assign out = mult_result;
    assign out_lo = mult_lo;

    // Minimum value module
    reg [7:0] min_val;
    always @ (a or b or c or d) begin
        if (a <= b && a <= c && a <= d) begin
            min_val <= a;
        end else if (b <= c && b <= d) begin
            min_val <= b;
        end else if (c <= d) begin
            min_val <= c;
        end else begin
            min_val <= d;
        end
    end
    assign final_out = min_val + out_lo;

endmodule
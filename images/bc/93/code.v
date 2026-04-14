module top_module(
    input       [7:0]   a,
    input       [7:0]   b,
    input               clk,
    input               rst,
    output reg  [7:0]   sum
);always @(posedge clk) begin
        if (rst) begin
            sum <= 8'b0;
        end else begin
            sum <= a + b;
        end
    end

endmodule
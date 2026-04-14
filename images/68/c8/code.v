module top_module(
    input clk,
    input rst,
    input [3:0] a,
    input [3:0] b,
    input sub,
    output reg [3:0] result,
    output reg overflow
);always @(posedge clk, posedge rst) begin
    if (rst) begin
        result <= 4'b0;
        overflow <= 1'b0;
    end else begin
        if (sub) begin
            result <= a - b;
            overflow <= (a[3] & ~b[3] & ~result[3]) | (~a[3] & b[3] & result[3]);
        end else begin
            result <= a + b;
            overflow <= (result[3] & (a[3] | b[3])) | (~result[3] & ~(a[3] | b[3]));
        end
    end
end

endmodule
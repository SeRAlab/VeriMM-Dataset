module top_module(
    input clk,
    input rst,
    input op,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg valid
);reg [7:0] sum;
reg [7:0] diff;

always @(posedge clk) begin
    if (rst) begin
        out <= 0;
        valid <= 0;
    end else begin
        if (op == 0) begin
            sum <= a + b;
            out <= sum;
        end else begin
            diff <= a - b;
            out <= diff;
        end
        valid <= 1;
    end
end

endmodule
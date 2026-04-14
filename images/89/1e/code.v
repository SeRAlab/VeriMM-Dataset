module top_module(
    input clk,
    input rst,
    input [7:0] a,
    input [3:0] b,
    output reg [11:0] c
);always @(posedge clk) begin
    if(rst) begin
        c <= 0;
    end else begin
        c <= a + (b << 8);
    end
end

endmodule
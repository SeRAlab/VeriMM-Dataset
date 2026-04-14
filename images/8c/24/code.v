module top_module(
    input [7:0] d,
    input clk,
    input en,
    output reg [7:0] q);

always @(posedge clk) begin
    if (en)
        q <= d;
end

endmodule
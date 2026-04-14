module top_module(
    input [7:0] in,
    output reg [3:0] out,
    input clk,
    input reset
);reg [7:0] constant = 8'b10101010;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        out <= 4'b0;
    end else begin
        out <= {in ^ constant} + 4'b1;
    end
end

endmodule
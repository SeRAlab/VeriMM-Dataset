module top_module(
    input clk,
    input rst,
    input [3:0] bin,
    output [3:0] gray
);reg [3:0] gray_reg;

always @(posedge clk) begin
    if (rst) begin
        gray_reg <= 4'b0;
    end else begin
        gray_reg <= bin ^ (bin >> 1);
    end
end

assign gray = gray_reg;

endmodule
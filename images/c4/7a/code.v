module bin2gray (
    input [3:0] bin,
    output [3:0] gray,
    input reset,
    input clk
);

reg [3:0] gray_reg;

always @(posedge clk) begin
    if (reset) begin
        gray_reg <= 4'b0000;
    end else begin
        gray_reg <= bin ^ (bin >> 1);
    end
end

assign gray = gray_reg;

endmodule
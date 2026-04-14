module top_module(
    input clk,
    input rst,
    input ena,
    input [3:0] gray,
    output reg [3:0] binary
);reg [3:0] gray_reg1, gray_reg2;
reg [3:0] binary_reg1, binary_reg2;

always @(posedge clk) begin
    if (rst) begin
        gray_reg1 <= 4'b0000;
        gray_reg2 <= 4'b0000;
        binary_reg1 <= 4'b0000;
        binary_reg2 <= 4'b0000;
    end else if (ena) begin
        gray_reg1 <= gray;
        gray_reg2 <= gray_reg1;
        binary_reg1 <= binary_reg2;
        binary_reg2 <= binary_reg1 ^ gray_reg2;
    end
end

assign binary = binary_reg2;

endmodule
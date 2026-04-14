module top_module(
    input [3:0] B,
    input EN,
    output [3:0] G
);reg [3:0] gray_reg1, gray_reg2, gray_reg3;

assign G = EN ? gray_reg3 : G;

always @ (posedge EN)
begin
    gray_reg1 <= B;
    gray_reg2 <= gray_reg1 ^ (gray_reg1 >> 1);
    gray_reg3 <= gray_reg2 ^ (gray_reg2 >> 2);
end

endmodule
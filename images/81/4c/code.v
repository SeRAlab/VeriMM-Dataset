module reg_8bit (
    input clk,
    input en,
    input clr,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge clr)
    if (clr)
        q <= 8'b00000000;
    else if (en)
        q <= d;

endmodule
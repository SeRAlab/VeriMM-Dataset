module register_with_clear (
    input clk,
    input clr,
    input [7:0] data_in,
    output reg [7:0] q
);

always @(posedge clk or posedge clr)
    if (clr)
        q <= 8'b00000000;
    else
        q <= data_in;

endmodule
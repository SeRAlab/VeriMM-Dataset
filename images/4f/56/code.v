module shift_register(
    input clk,
    input rst,
    input din,
    output reg [7:0] dout
);

always @(posedge clk or posedge rst)
    if (rst)
        dout <= 8'b00000000;
    else
        dout <= {1'b0, dout[7:1]};

endmodule
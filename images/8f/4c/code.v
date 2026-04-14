module counter_3bit_updown(
    input clk,
    input rst,
    input mode,
    output reg [2:0] count
);

always @(posedge clk)
    if (rst)
        count <= 3'b000;
    else if (mode)
        count <= count + 1;
    else
        count <= count - 1;

endmodule
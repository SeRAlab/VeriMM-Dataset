module counter_4bit(
    input clk,
    input rst,
    input en,
    output reg [3:0] count
);

always @(posedge clk)
    if (rst)
        count <= 4'b0000;
    else if (en)
        count <= count + 1;

endmodule
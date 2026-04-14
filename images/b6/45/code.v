module up_counter(
    input clk,
    input rst,
    output reg [2:0] count
);

always @(posedge clk or posedge rst)
    if (rst)
        count <= 3'b000;
    else
        count <= count + 1;

endmodule
module up_down_counter (
    input rst,
    input clk,
    input up,
    input down,
    output reg [2:0] count
);

always @(posedge clk)
    if (rst)
        count <= 3'b000;
    else if (up && !down)
        count <= count + 1;
    else if (!up && down)
        count <= count - 1;

endmodule
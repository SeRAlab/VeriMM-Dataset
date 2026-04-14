module top_module (
    input clk,
    input reset,
    input dir,
    output reg [2:0] count);always @(posedge clk or posedge reset)
    if (reset)
        count <= 0;
    else if (dir)
        count <= count + 1;
    else
        count <= count - 1;

endmodule
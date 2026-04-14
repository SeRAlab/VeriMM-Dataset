module counter(
    input clk,
    input reset,
    input up,
    output reg [3:0] count);always @(posedge clk)
    if (reset)
        count <= 0;
    else if (up)
        count <= count + 1;
    else
        count <= count - 1;
        
endmodule
module top_module(
    input clk,
    input set_min,
    input [3:0] clock1,
    input [3:0] clock2,
    input [3:0] temp1,
    input [3:0] temp2,
    output reg [3:0] clock_min1,
    output reg [3:0] clock_min2
    );always @(posedge clk or posedge set_min)
        if(set_min)
        begin
            clock_min1 <= clock1;
            clock_min2 <= clock2;
        end
        else
        begin
            clock_min1 <= temp1;
            clock_min2 <= temp2;
        end
endmodule
module top_module(
    input [15:0] count,
    input [3:0] ring,
    output [3:0] digit
    );assign digit = {4{ring[3]}} & count[15:12] | 
                    {4{ring[2]}} & count[11:8]  |
                    {4{ring[1]}} & count[7:4]   |
                    {4{ring[0]}} & count[3:0];
    
endmodule
module top_module(output [3:0] s, output [3:0] s1, output [7:0] sFim,
                    input  [3:0] a, 
                    input  [3:0] b);assign s = a | b ;
assign s1 = a&b;
assign sFim[3:0] = s;
assign sFim[7:4] = s1;endmodule
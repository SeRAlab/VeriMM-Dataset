module top_module(output [3:0] s1, output [3:0] s2,output [3:0] s3,output [3:0] s4,output [3:0] s5,
          output [3:0] s6,output [3:0] s7,output [3:0] s8,output [7:0] sFim,
                    input  [3:0] a,
                    input  [3:0] b,
                    input  [3:0] c);assign s1 = a&b;
assign s2 = a|b;


assign s3 = ~(a&b);
assign s4 = ~(a|b);


assign s5 = s1&~c;
assign s6 = s2&~c;
assign s7 = s3&c;
assign s8 = s4&c;


assign sFim[7:4] = s5|s7;
assign sFim[3:0] = s6|s8;endmodule
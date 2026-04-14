module top_module(input [41:0] xxx,input [1:0] yyy,output [41:0] zzz);assign zzz = xxx+ { {40{1'b0}},yyy }; 
 endmodule
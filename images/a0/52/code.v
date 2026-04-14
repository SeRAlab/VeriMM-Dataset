module top_module(input D,input clk,output reg Q);always @(posedge clk) 
        #15 Q <= D;
endmodule
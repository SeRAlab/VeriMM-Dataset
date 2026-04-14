module top_module(input [31:0] A,input [31:0] WD,input WE,output [31:0] RD,input clk);reg [31:0] mem [0:31]; 
 assign RD = mem[A[6:2]]; 
 always @(posedge clk) begin 
 if(WE)begin 
 mem[A[6:2]] <= WD; 
 end 
 end 
 endmodule
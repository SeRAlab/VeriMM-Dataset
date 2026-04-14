module top_module(input wire [3:0] addr,input wire clk,input wire wrenb,input wire din,output wire dout,output wire hit);reg [15:0] mem; 
 always @(posedge clk) 
 if (wrenb) mem <= {mem, din}; 
 assign hit = mem[addr]; 
 assign dout = mem[15]; 
 endmodule
module top_module(clk, pixaddr, ven, qpixel, breq, back);parameter ADDR_SIZE = 32; 
 localparam PIXEL_SIZE = 32; 
 input clk; 
 input [ADDR_SIZE-1:0] pixaddr; 
 input ven; 
 output [PIXEL_SIZE-1:0] qpixel; 
 output breq; 
 input back; 
 always @(posedge clk) 
 begin 
 end 
 endmodule
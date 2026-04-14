module top_module(input wire [15:0] addr,input wire we,input wire clk,input wire bytew,input wire [15:0] d_in,output wire [15:0] d_out);reg [15:0] memory [64*512-1:0]; 
  wire [15:0] word = memory [addr[15:1]]; 
  assign d_out = addr[0] ? 
  (word >> 8) : 
  word; 
  always @(posedge clk) begin 
  if (we == 1) begin 
  if (bytew) begin 
  if (addr[1]) begin 
  memory [addr[15:1]] = { d_in[7:0], word[7:0] }; 
  $display ("(%0d) store %h := %h", $time, {addr[15:1], 1'b0}, { d_in[7:0], word[7:0] }); 
  end else begin 
  memory [addr[15:1]] = { word[15:8], d_in[7:0] }; 
  $display ("(%0d) store %h := %h", $time, {addr[15:1], 1'b0}, { word[15:8], d_in[7:0] }); 
  end 
  end else begin 
  memory [addr[15:1]] = d_in; 
  $display ("(%0d) store %h := %h", $time, {addr[15:1], 1'b0}, d_in); 
  end 
  end 
  end 
 endmodule
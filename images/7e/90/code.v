module top_module(input wire clk,output wire [31:0] data_o,input wire [31:0] addr_i);reg [31:0] data_ff; 
 always @(posedge clk) begin 
  case (addr_i) 
 16'h0000: data_ff <= 32'h00000000; 
 16'h0001: data_ff <= 32'h00000000; 
 16'h0002: data_ff <= 32'h00000000; 
 16'h0003: data_ff <= 32'h00000000; 
 16'h0004: data_ff <= 32'h01010001; 
 16'h0005: data_ff <= 32'h02010002; 
 16'h0006: data_ff <= 32'h03010003; 
 16'h0007: data_ff <= 32'h04010004; 
 16'h0008: data_ff <= 32'h05000100; 
 16'h0009: data_ff <= 32'h06000200; 
 16'h000a: data_ff <= 32'h07000300; 
 16'h000b: data_ff <= 32'h08000400; 
 16'h000c: data_ff <= 32'h80010004; 
 16'h000d: data_ff <= 32'h00000000; 
 16'h000e: data_ff <= 32'h00000000; 
 16'h000f: data_ff <= 32'h00000000; 
 16'h0010: data_ff <= 32'h00000000; 
 default: data_ff <= 32'h80010001; 
  endcase 
 end 
 assign data_o = data_ff; 
 endmodule
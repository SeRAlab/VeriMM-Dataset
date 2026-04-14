module top_module(input clk,input clk7_en,input reset,input [15:0] data_in,output reg [15:0] data_out,input rd,input wr,output full,output empty,output last);reg [15:0] mem [4095:0]; 
 reg [12:0] inptr; 
 reg [12:0] outptr; 
 wire empty_rd; 
 reg empty_wr; 
 always @(posedge clk) 
  if (clk7_en) begin 
  if (wr) 
  mem[inptr[11:0]] <= data_in; 
  end 
 always @(posedge clk) 
  if (clk7_en) begin 
  data_out <= mem[outptr[11:0]]; 
  end 
 always @(posedge clk) 
  if (clk7_en) begin 
  if (reset) 
  inptr <= 12'd0; 
  else if (wr) 
  inptr <= inptr + 12'd1; 
  end 
 always @(posedge clk) 
  if (clk7_en) begin 
  if (reset) 
  outptr <= 0; 
  else if (rd) 
  outptr <= outptr + 13'd1; 
  end 
 assign empty_rd = inptr==outptr ? 1'b1 : 1'b0; 
 always @(posedge clk) 
  if (clk7_en) begin 
  empty_wr <= empty_rd; 
  end 
 assign empty = empty_rd | empty_wr; 
 assign full = inptr[12:8]!=outptr[12:8] ? 1'b1 : 1'b0; 
 assign last = outptr[7:0] == 8'hFF ? 1'b1 : 1'b0; 
 endmodule
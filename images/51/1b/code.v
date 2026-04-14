module top_module(input wire clk,input wire resetn,output wire mem_valid,input wire mem_ready,output wire mem_instr,output wire [31:0] mem_addr,output wire [3:0] mem_wstrb,output wire [31:0] mem_wdata,input wire [31:0] mem_rdata,input wire tick);reg [3:0] counter; 
  always @(posedge clk) begin 
  if (!resetn) begin 
  counter <= 0; 
  end else begin 
  if (tick) begin 
  counter <= counter + 4'd1; 
  end 
  end 
  end 
  assign mem_valid = tick; 
  assign mem_instr = 1'b0; 
  assign mem_addr = tick ? 32'hffff0060 : 32'b0; 
  assign mem_wstrb = tick ? 4'b1 : 4'b0; 
  assign mem_wdata = tick ? counter : 32'b0; 
 endmodule
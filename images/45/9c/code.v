module top_module(input clk_i,input reset_i,input cyc_i,input stb_i,input we_i,input [1:0] sel_i,input [19:1] adr_i,input [15:0] dat_i,output ack_o,output [15:0] dat_o,output stall_o,output _sram_ce,output _sram_we,output _sram_oe,output _sram_ub,output _sram_lb,output [19:1] sram_a,output [15:0] sram_d_out,input [15:0] sram_d_in);reg transfer; 
  reg [1:0] selects; 
  reg write; 
  reg [15:0] data_in; 
  reg [19:1] address; 
  assign ack_o = transfer; 
  wire sram_we = transfer & write & ~clk_i; 
  wire sram_oe = transfer & ~write & ~clk_i; 
  assign _sram_ce = 0; 
  assign _sram_we = ~sram_we; 
  assign _sram_oe = ~sram_oe; 
  assign _sram_ub = ~selects[1]; 
  assign _sram_lb = ~selects[0]; 
  assign dat_o = sram_oe ? sram_d_in : 0; 
  assign sram_a = address; 
  assign sram_d_out = data_in; 
  assign stall_o = 0; 
  always @(posedge clk_i) begin 
  transfer <= cyc_i & stb_i; 
  selects <= sel_i; 
  write <= we_i; 
  address <= adr_i; 
  data_in <= dat_i; 
  end 
 endmodule
module top_module(input [31:0] wb_dat_i,output reg [31:0] wb_dat_o,input [35:0] wb_adr_i,input wb_we_i,input [3:0] wb_sel_i,input wb_stb_i,input wb_cyc_i,output reg wb_ack_o,input [31:0] gpio_in,output [31:0] gpio_out,input clk);reg [31:0] gpio_in_reg = 32'h00000000; 
 reg [31:0] gpio_out_reg = 32'h00000000; 
 wire gpio_write; 
 assign gpio_out = gpio_out_reg; 
 assign gpio_write = wb_stb_i && wb_we_i && wb_adr_i[0]; 
 always @(posedge clk) begin 
  gpio_in_reg <= gpio_in; 
  if (gpio_write) 
  gpio_out_reg <= wb_dat_i; 
  if (wb_stb_i) begin 
  wb_dat_o <= wb_adr_i[31:0]; 
  wb_ack_o <= 1'b1; 
  end else begin 
  wb_ack_o <= 1'b0; 
  end 
 end 
 endmodule
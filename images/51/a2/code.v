module top_module(input clk,input [4:0] gpr_ra_a,input [4:0] gpr_ra_b,input [4:0] gpr_wa,input [31:0] gpr_wd,input gpr_we,output [31:0] gpr_rd_a,output [31:0] gpr_rd_b);reg [31:0] registers [1:31]; 
  always @ ( posedge clk ) begin 
  if(gpr_wa != 5'b0) 
  registers[gpr_wa] <= (gpr_we) ? gpr_wd : registers[gpr_wa]; 
  end 
  assign gpr_rd_a = (gpr_ra_a == 5'b0) ? 32'b0 : registers[gpr_ra_a]; 
  assign gpr_rd_b = (gpr_ra_b == 5'b0) ? 32'b0 : registers[gpr_ra_b]; 
 endmodule
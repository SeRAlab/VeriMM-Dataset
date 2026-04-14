module top_module(rs1_l, rs2, valid, areg, accreg, x2, out, rclk, si, so, se,mul_rst_l, mul_step);input [63:0] rs1_l; 
  input [63:0] rs2; 
  input valid; 
  input [96:0] areg; 
  input [135:129] accreg; 
  input x2; 
  input rclk; 
  input si; 
  input se; 
  input mul_rst_l; 
  input mul_step; 
  output so; 
  output [135:0] out; 
 reg [135:0] myout, myout_a1, myout_a2, myout_a3; 
 reg [63:0] rs1_ff; 
 reg [64:0] rs2_ff; 
 reg [63:0] par1, par2; 
 reg [64:0] par3, par4; 
 reg [5:0] state; 
 always @(posedge rclk) 
  state <= {valid,state[5:1]}; 
 always @(posedge rclk) begin 
  if(mul_step) begin 
  if(valid) begin 
  rs1_ff <= ~rs1_l; 
  rs2_ff <= x2 ? {rs2,1'b0} : {1'b0,rs2}; 
  end else begin 
  rs1_ff <= {32'b0, rs1_ff[63:32]}; 
  end 
  par1 <= (rs1_ff[31:0] * rs2_ff[31:0]); 
  par3 <= rs1_ff[31:0] * rs2_ff[64:32]; 
  myout_a1 <= ({32'b0, myout_a1[135:32]} & {136{state[3]}}) + par1 + {par3, 32'b0} + areg; 
  myout <= {(myout_a1[103:97]+accreg),myout_a1[96:0],myout[63:32]}; 
  end 
 end 
 assign out = myout; 
 assign so = 1'b0; 
 endmodule
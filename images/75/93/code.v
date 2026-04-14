module top_module(input wire clk,input wire reset_n,input wire init,input wire update,input wire [63 : 0] opa,input wire [31 : 0] opb,output wire [63 : 0] res);reg [63 : 0] mulacc_res_reg; 
  reg [63 : 0] mulacc_res_new; 
  assign res = mulacc_res_reg; 
  always @ (posedge clk) 
  begin : reg_update 
  if (!reset_n) 
  begin 
  mulacc_res_reg <= 64'h0; 
  end 
  else 
  begin 
  if (update) 
  mulacc_res_reg <= mulacc_res_new; 
  end 
  end 
  always @* 
  begin : mac_logic 
  reg [63 : 0] mul_res; 
  reg [63 : 0] mux_addop; 
  mul_res = opa * opb; 
  if (init) 
  mux_addop = 64'h0; 
  else 
  mux_addop = mulacc_res_reg; 
  mulacc_res_new = mul_res + mux_addop; 
  end 
 endmodule
module top_module(input CLK,input input_IN, wren_IN,input [2:0] writeAd_IN,input ADR_MUX_IN, write_IN, PC_load_IN,input SPR_w_IN, SPR_i_IN, SPR_d_IN,input [2:0] cond_IN, op2_IN,input SW_IN, MAD_MUX_IN,output input_OUT, wren_OUT,output [2:0] writeAd_OUT,output ADR_MUX_OUT, write_OUT, PC_load_OUT,output SPR_w_OUT, SPR_i_OUT, SPR_d_OUT,output [2:0] cond_OUT, op2_OUT,output SW_OUT, MAD_MUX_OUT);reg in, wren; 
  reg [2:0] writeAd; 
  reg adrmux, write, pcload; 
  reg [2:0] cond, opera2; 
  reg sprw,spri,sprd; 
  reg sw, mad; 
  always @ (posedge CLK) begin 
  in <= input_IN; 
  wren <= wren_IN; 
  writeAd <= writeAd_IN; 
  adrmux <= ADR_MUX_IN; 
  write <= write_IN; 
  pcload <= PC_load_IN; 
  cond <= cond_IN; 
  opera2 <= op2_IN; 
  sprw <= SPR_w_IN; 
  spri <= SPR_i_IN; 
  sprd <= SPR_d_IN; 
  sw <= SW_IN; 
  mad <= MAD_MUX_IN; 
  end 
  assign input_OUT = in; 
  assign wren_OUT = wren; 
  assign writeAd_OUT = writeAd; 
  assign ADR_MUX_OUT = adrmux; 
  assign write_OUT = write; 
  assign PC_load_OUT = pcload; 
  assign cond_OUT = cond; 
  assign op2_OUT = opera2; 
  assign SPR_w_OUT = sprw; 
  assign SPR_i_OUT = spri; 
  assign SPR_d_OUT = sprd; 
  assign SW_OUT = sw; 
  assign MAD_MUX_OUT = mad; 
 endmodule
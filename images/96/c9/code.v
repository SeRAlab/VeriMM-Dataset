module top_module(
  input [23:0] in,
  output [15:0] out
);wire [15:0] outmux0, outmux1, outmux2, outmux3;
  wire [15:0] result;
  wire slc0, slc1, slc4; 
  
  
  
  assign outmux0 = slc0 ? 16'h3000 : 16'h5000;
  
  assign outmux1 = slc1 ? outmux0 : 16'h4000;
  
  assign outmux2 = slc1 ? in[23:8] : in[22:7];
  
  assign outmux3 = slc0 ? 16'h0 : 16'h7FFF;
  
  assign out = slc4 ? outmux3 : result;
  
  
  assign slc0 = in[23];                           
  assign slc1 = (in<24'hF00000)&&(in>24'h100000); 
  assign slc4 = (in<24'hD00000)&&(in>24'h300000); 
  
  assign result = outmux2 + outmux1; 
endmodule
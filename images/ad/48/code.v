module top_module(datain0,datain1, dataout, select);input [31:0] datain0, datain1; 
 input select; 
 output [31:0] dataout; 
 reg [31:0] dataout; 
 always @(datain0 or datain1 or select) 
 begin 
 if (select == 0) 
  dataout = datain0; 
 else 
  dataout = datain1; 
 end 
 endmodule
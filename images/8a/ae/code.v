module top_module(input [47:0] X,input [59:0] Y,output reg [47:0] Dout,input CLK);wire [47:0] Xtmp; 
 always @(posedge CLK) 
 begin 
  Dout <= Xtmp ^ Y[47:0]; 
 end 
 assign Xtmp = {(X[47:36] & (~Y[59:48])) | (Y[59:48] & X[23:12]), X[35:24], (X[23:12] & (~Y[59:48])) | (Y[59:48] & X[47:36]), X[11:0]}; 
 endmodule
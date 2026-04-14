module top_module(
         rd_stage,mode_SSHRin,rst,clk);input[3:0] rd_stage;
  output reg mode_SSHRin;
  input rst,clk;
  
  
  
  
  
  always @(posedge clk)
  begin
    if (rst) mode_SSHRin = 1'b0;
    else mode_SSHRin = &{rd_stage[2],rd_stage[0]} || &{rd_stage[3],rd_stage[1]};
  end 
endmodule
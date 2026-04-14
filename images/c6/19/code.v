module pwmregister(
  output reg [7:0] pwmval,
  input clk,
  input pwmldce,
  input [7:0] wrtdata);
  
  always@(posedge clk) begin
    if(pwmldce) begin
      pwmval <= wrtdata;
    end
  end 
endmodule
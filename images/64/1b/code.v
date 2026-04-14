module top_module(
  output sout,
  input [7:0] outbyte,
  input ld,
  input clk);reg [7:0] register = 8'h00;
  
  assign sout = register[7]; 
 
  always @(negedge clk) begin
    if(ld) begin
      register <= outbyte;
    end
    else begin
      register[7:1] <= register[6:0];
      register[0] <= 0;
    end
  end
endmodule
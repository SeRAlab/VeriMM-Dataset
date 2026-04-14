module top_module(
  output out,
  input [7:0] parallelin,
  input rdld,
  input clk);reg [7:0] dinregister = 8'h00;
  
  assign out = dinregister[7];
 
  always @(negedge clk) begin
    if(rdld)
      dinregister <= parallelin;
    else begin
      dinregister[7:1] <= dinregister[6:0];
    end
  end
endmodule
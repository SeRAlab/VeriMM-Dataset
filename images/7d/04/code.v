module top_module(
 input  wire CLK,
 input  wire IN,
 output wire OUT
);reg [1:0] delay;

assign OUT = delay[1];



always @(posedge CLK)
  begin
   delay[1] <= delay[0];  delay[0] <= IN;
  end
  


endmodule
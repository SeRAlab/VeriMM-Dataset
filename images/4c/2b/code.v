module top_module(
   
   line0, line1, out,
   
   clk, in
   );input clk;
   input [89:0] in;   
   
   output reg [44:0]	line0;
   output reg [44:0]	line1;   
   output reg [89:0]	out;      
   
   assign  {line0,line1} = in;
   always @(posedge clk) begin
      out <= {line0,line1};
   end
endmodule
module top_module(
   input 			clk,
   input [89:0] 		in,
   output [89:0] 		out,
   output [44:0] 		line0,
   output [44:0] 		line1
);reg [89:0] 			reg_in;
   reg [89:0] 			reg_out;
   reg [44:0] 			reg_line0;
   reg [44:0] 			reg_line1;

   always @ (posedge clk) begin
      reg_in <= in;
      reg_out <= reg_in;
      reg_line0 <= {reg_in[44:0], reg_in[44:0]};
      reg_line1 <= {reg_in[89:45], reg_in[89:45]};
   end

   assign out = reg_out;
   assign line0 = reg_line0;
   assign line1 = reg_line1;

endmodule
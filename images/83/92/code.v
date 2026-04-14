module top_module(CLK, RST, Q_OUT, D_IN, EN);parameter width = 1;
   parameter init = { width {1'b0}} ;

   input     CLK;
   input     RST;
   input     EN;
   input [width - 1 : 0] D_IN;
   output [width - 1 : 0] Q_OUT;

   reg [width - 1 : 0]    Q_OUT;

   always@(posedge CLK or posedge RST) begin
      if (RST) begin
        Q_OUT <= init; // Removed the undefined macro
      end else if (EN) begin
        Q_OUT <= D_IN; // Removed the undefined macro
      end
   end // always@ (posedge CLK or posedge RST)

endmodule
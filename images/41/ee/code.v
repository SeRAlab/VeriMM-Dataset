module top_module(CLK, RST, Q_OUT, D_IN, EN);parameter width = 1;
   parameter init = { width {1'b0}} ;

   input     CLK;
   input     RST;
   input     EN;
   input [width - 1 : 0] D_IN;
   output [width - 1 : 0] Q_OUT;

   reg [width - 1 : 0]    Q_OUT;

   always@(posedge CLK or negedge RST) begin
      if (RST == 0)
        Q_OUT <= #1 init;
      else
        begin
           if (EN)
             Q_OUT <= #1 D_IN;
        end
   end // always@ (posedge CLK or negedge RST)

endmodule
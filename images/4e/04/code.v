module top_module(CLK, RESET, CHAR_IN, ROW_NUM, DATA_OUT);input    wire  [7:0]  CHAR_IN;
   input    wire  [3:0]  ROW_NUM;
   input    wire         CLK;
   input    wire         RESET;
   output   reg   [9:0]  DATA_OUT;
   
   parameter   char       = 8'h48;
   parameter   font_value = 160'h4210842108421F842108421084200000;
   
   reg [159:0] char_font;
   
   always @(negedge CLK) begin
      if (!RESET) begin
         char_font = font_value;
      end
      else if (CHAR_IN == char) begin
         DATA_OUT = char_font[10*ROW_NUM+:10];
      end
      else begin
         DATA_OUT = 10'bZZ;
      end
   end

endmodule
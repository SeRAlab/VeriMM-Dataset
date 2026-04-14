module top_module(input  wire [3:0] value,
                input  wire       blank,
                input  wire       minus,
                output reg  [6:0] s7);always @*
      if (blank)
        s7 = ~7'b0000000;
      else if ( minus )
        s7 = ~7'b1000000;
      else case (value)
             4'h0: s7 = ~7'b0111111;
             4'h1: s7 = ~7'b0000110;
             4'h2: s7 = ~7'b1011011;
             4'h3: s7 = ~7'b1001111;
             4'h4: s7 = ~7'b1100110;
             4'h5: s7 = ~7'b1101101;
             4'h6: s7 = ~7'b1111101;
             4'h7: s7 = ~7'b0000111;
             4'h8: s7 = ~7'b1111111;
             4'h9: s7 = ~7'b1101111;
             4'hA: s7 = ~7'b1110111;
             4'hB: s7 = ~7'b1111100;
             4'hC: s7 = ~7'b0111001;
             4'hD: s7 = ~7'b1011110;
             4'hE: s7 = ~7'b1111001;
             4'hF: s7 = ~7'b1110001;
           endcase
endmodule
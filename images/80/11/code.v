module top_module(
            input wire  [9:0] x_px,
            output wire [2:0] color_px
);localparam barwidth = 80;  


assign color_px =  ((x_px >= 0*barwidth) && (x_px < 1*barwidth)) ? 3'b111 : 
                  (((x_px >= 1*barwidth) && (x_px < 2*barwidth)) ? 3'b110 : 
                  (((x_px >= 2*barwidth) && (x_px < 3*barwidth)) ? 3'b101 :
                  (((x_px >= 3*barwidth) && (x_px < 4*barwidth)) ? 3'b100 :
                  (((x_px >= 4*barwidth) && (x_px < 5*barwidth)) ? 3'b011 :
                  (((x_px >= 5*barwidth) && (x_px < 6*barwidth)) ? 3'b010 :
                  (((x_px >= 6*barwidth) && (x_px < 7*barwidth)) ? 3'b001 : 3'b000 ))))));
endmodule
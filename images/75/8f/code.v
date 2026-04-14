module mux_8to1 (d0, d1, d2, d3, d4, d5, d6, d7, sel, y);
   input d0, d1, d2, d3, d4, d5, d6, d7;
   input [2:0] sel;
   output y;

   assign y = (sel == 3'b000) ? d0 :
              (sel == 3'b001) ? d1 :
              (sel == 3'b010) ? d2 :
              (sel == 3'b011) ? d3 :
              (sel == 3'b100) ? d4 :
              (sel == 3'b101) ? d5 :
              (sel == 3'b110) ? d6 :
                                d7;
endmodule
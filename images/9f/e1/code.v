module mux_2to1 (d0, d1, sel, y);
   input d0, d1;
   input sel;
   output y;

   assign y = sel ? d1 : d0;
endmodule
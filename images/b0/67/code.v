module mux_2to1 (sel, data_in0, data_in1, q);
   input sel;
   input data_in0, data_in1;
   output q;
   
   assign q = sel ? data_in1 : data_in0;
endmodule
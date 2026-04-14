module decoder_2to4 (a, y0, y1, y2, y3);
   input [1:0] a;
   output y0, y1, y2, y3;
   
   assign y0 = (a == 2'b00);
   assign y1 = (a == 2'b01);
   assign y2 = (a == 2'b10);
   assign y3 = (a == 2'b11);
   
endmodule
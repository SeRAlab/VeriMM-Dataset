module and_gate_with_enable (a, b, en, y);
   input a, b, en;
   output y;
   
   assign y = en ? (a & b) : 1'b0;
endmodule
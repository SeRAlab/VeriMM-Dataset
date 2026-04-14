module binary_to_gray_4bit (binary_in, gray_out);
   input [3:0] binary_in;
   output [3:0] gray_out;
   
   assign gray_out = binary_in ^ (binary_in >> 1);
endmodule
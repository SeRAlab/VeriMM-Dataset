module bin2gray (gray, bin);
   input [2:0] bin;
   output [2:0] gray;
   
   assign gray[2] = bin[2];
   assign gray[1] = bin[2] ^ bin[1];
   assign gray[0] = bin[1] ^ bin[0];
endmodule
module top_module( input A, B,
                   output S, 
                   input Cin,
                   output Cout );assign S = A ^ B ^ Cin;
   assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule
module top_module(twos_complement, sign_magnitude);output [15:0] twos_complement;
input [15:0] sign_magnitude;

assign twos_complement = sign_magnitude[15] ?
                         {sign_magnitude[15], ~sign_magnitude[14:0]} + 16'b1 :
                         sign_magnitude;

endmodule
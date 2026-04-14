module four_bit_adder
  (input [3:0] A, B, output reg [3:0] S, input Cin);
  
  always @ (A, B, Cin)
  begin
    if (Cin == 0)
      S = A + B;
    else
      S = A - B;
  end
  
endmodule
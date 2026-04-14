module top_module(I, O, S0, S1);input [3:0] I;
  output O;
  input S0, S1;
  
  reg [3:0] temp;
  always @ (S0, S1, I) begin
    case ({S1, S0})
      2'b00: temp = I[0];
      2'b01: temp = I[1];
      2'b10: temp = I[2];
      2'b11: temp = I[3];
    endcase
  end
  
  assign O = temp;
endmodule
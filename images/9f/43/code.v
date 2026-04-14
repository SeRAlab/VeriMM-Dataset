module top_module(
  input [11:0] I,
  input [1:0] select,
  output reg O
);always @(*) begin
    case (select)
      2'b00: O = I[0];
      2'b01: O = I[1];
      2'b10: O = I[2];
      2'b11: O = I[3];
    endcase
    case (select)
      2'b00: O = I[4];
      2'b01: O = I[5];
      2'b10: O = I[6];
      2'b11: O = I[7];
    endcase
    case (select)
      2'b00: O = I[8];
      2'b01: O = I[9];
      2'b10: O = I[10];
      2'b11: O = I[11];
    endcase
  end

endmodule
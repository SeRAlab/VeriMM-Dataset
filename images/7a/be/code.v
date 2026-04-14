module top_module(
  input [11:0] I,
  input [3:0] S,
  output reg O
);always @ (S or I) begin
    case(S)
      4'd0: O = I[0];
      4'd1: O = I[1];
      4'd2: O = I[2];
      4'd3: O = I[3];
      4'd4: O = I[4];
      4'd5: O = I[5];
      4'd6: O = I[6];
      4'd7: O = I[7];
      4'd8: O = I[8];
      4'd9: O = I[9];
      4'd10: O = I[10];
      4'd11: O = I[11];
      default: O = 1'b0;
    endcase
  end

endmodule
module decoder_3to8(
  input [2:0] binary_in,
  output reg [7:0] decoded_out
);

  always @(*) begin
    decoded_out = 8'b00000000;
    case(binary_in)
      3'd0: decoded_out = 8'b00000001;
      3'd1: decoded_out = 8'b00000010;
      3'd2: decoded_out = 8'b00000100;
      3'd3: decoded_out = 8'b00001000;
      3'd4: decoded_out = 8'b00010000;
      3'd5: decoded_out = 8'b00100000;
      3'd6: decoded_out = 8'b01000000;
      3'd7: decoded_out = 8'b10000000;
    endcase
  end

endmodule
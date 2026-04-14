module priority_encoder(
  input [4:0] data_in,
  output reg [2:0] binary_out,
  output reg valid
);

  always @(*) begin
    valid = 1'b1;
    case (data_in)
      5'b10000: binary_out = 3'b100;
      5'b01000: binary_out = 3'b011;
      5'b00100: binary_out = 3'b010;
      5'b00010: binary_out = 3'b001;
      5'b00001: binary_out = 3'b000;
      default: begin
        binary_out = 3'b000;
        valid = 1'b0;
      end
    endcase
  end

endmodule
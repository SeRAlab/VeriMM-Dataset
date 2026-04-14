module value_converter(
  input [3:0] input_val,
  output reg [2:0] output_val
);

always @(*) begin
  case(input_val)
    4'd5, 4'd6: output_val = 3'd7;
    default: output_val = input_val[2:0];
  endcase
end

endmodule
module top_module(
    input [2:0] select,
    input [7:0] input_data,
    output reg output_data
);always @* begin
    case (select)
      3'b000: output_data = input_data[0];
      3'b001: output_data = input_data[1];
      3'b010: output_data = input_data[2];
      3'b011: output_data = input_data[3];
      3'b100: output_data = input_data[4];
      3'b101: output_data = input_data[5];
      3'b110: output_data = input_data[6];
      3'b111: output_data = input_data[7];
    endcase
  end
endmodule
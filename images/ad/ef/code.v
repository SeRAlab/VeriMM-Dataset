module top_module(
  input [7:0] num,
  input [3:0] shift_amount,
  input [1:0] control,
  output [7:0] result
);reg [7:0] shifted_num;

  always @(*) begin
    case(control)
      2'b00: shifted_num = num << shift_amount; // left shift
      2'b01: shifted_num = num >> shift_amount; // right shift
      2'b10: shifted_num = $signed(num) >>> shift_amount; // arithmetic shift
      default: shifted_num = 8'h00; // default value
    endcase
  end

  assign result = shifted_num;

endmodule
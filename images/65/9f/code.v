module top_module(
  input [31:0] num,
  input [4:0] shift,
  input [1:0] op_sel,
  output [31:0] result
);reg [31:0] shifted_num;

  always @(*) begin
    case (op_sel)
      2'b00: shifted_num = num << shift; // left shift
      2'b01: shifted_num = num >>> shift; // arithmetic shift
      2'b10: shifted_num = num >> shift; // right shift
      default: shifted_num = num; // no shift
    endcase
  end

  assign result = shifted_num;

endmodule
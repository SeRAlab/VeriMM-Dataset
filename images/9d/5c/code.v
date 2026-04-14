module top_module(a_in, b_in, op, c_out);input [7:0] a_in, b_in;
  input [1:0] op;
  output reg [7:0] c_out;

  always @(*) begin
    case (op)
      2'b00: c_out = a_in + b_in; // addition
      2'b01: c_out = a_in - b_in; // subtraction
      2'b10: c_out = a_in * b_in; // multiplication
      2'b11: c_out = a_in / b_in; // division
      default: c_out = 8'b0; // default case
    endcase
  end
endmodule
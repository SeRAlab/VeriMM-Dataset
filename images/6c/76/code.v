module top_module(
    input [1:0] code_in,
    output reg [3:0] code_out
    );always @(code_in)
  case (code_in)
     2'b00: code_out =4'b0001;
     2'b01: code_out =4'b0010;
     2'b10: code_out =4'b0100;
     2'b11: code_out =4'b1000;
  endcase

endmodule
module top_module(
  input [2:0] A,
  input [2:0] B,
  output reg [1:0] Y
);always @(*) begin
    case({A > B, A < B})
      2'b00: Y = 2'b00;
      2'b01: Y = 2'b01;
      2'b10: Y = 2'b10;
    endcase
  end

endmodule
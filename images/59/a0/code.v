module top_module(
  input [2:0] ctrl,
  output reg [3:0] td_mode
);always @(*) begin
    case(ctrl)
      3'b000: td_mode = 4'b0000;
      3'b001: td_mode = 4'b1000;
      3'b010: td_mode = 4'b0100;
      3'b011: td_mode = 4'b1100;
      3'b100: td_mode = 4'b0010;
      3'b101: td_mode = 4'b1010;
      3'b110: td_mode = 4'b0101;
      3'b111: td_mode = 4'b1111;
    endcase
  end

endmodule
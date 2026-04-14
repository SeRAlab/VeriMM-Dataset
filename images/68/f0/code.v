module top_module(
  input [2:0] state,
  input [11:0] value,
  input [4:0] index,
  output reg [31:0] temp
);always @(*) begin
  case(state)
    3'd1, 3'd2: temp = {8'h8, 24'h1};
    default: temp = {12'h3F, value, 8'h0};
  endcase
end

endmodule
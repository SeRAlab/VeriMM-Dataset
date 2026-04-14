module top_module(
  input x, y, z,
  output reg out
);always@(*)
begin
  case ({x, y, z})
  3'b000: begin out = 0; end
  3'b001: begin out = 0; end
  3'b010: begin out = 0; end
  3'b110: begin out = 0; end
  default: begin out = 1; end
  endcase
end

endmodule
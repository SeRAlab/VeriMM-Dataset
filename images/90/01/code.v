module top_module(
  input [2:0] data,
  output reg q
);always @* begin
    case(data)
      3'b000: q = 1'b1;
      3'b001: q = 1'b0;
      3'b010: q = 1'b0;
      3'b011: q = 1'b1;
      3'b100: q = 1'b0;
      3'b101: q = 1'b1;
      3'b110: q = 1'b1;
      3'b111: q = 1'b0;
      default: q = 1'b0;
    endcase
  end
  
endmodule
module top_module(
  input [2:0] bin,
  output reg [2:0] gray
);always @* begin
    case (bin)
      3'b000: gray = 3'b000;
      3'b001: gray = 3'b001;
      3'b010: gray = 3'b011;
      3'b011: gray = 3'b010;
      3'b100: gray = 3'b110;
      3'b101: gray = 3'b111;
      3'b110: gray = 3'b101;
      3'b111: gray = 3'b100;
      default: gray = 3'b000;
    endcase
  end

endmodule
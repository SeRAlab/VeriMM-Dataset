module top_module(
  input clk,
  input reset,
  output reg [3:0] out,
  output reg carry,
  output reg [6:0] seg // Changed from wire to reg
);always @(posedge clk) begin
    if (reset) begin
      out <= 4'b0000;
      carry <= 1'b0;
    end else begin
      if (out == 4'b1001) begin
        out <= 4'b0000;
        carry <= 1'b1;
      end else begin
        out <= out + 1;
        carry <= 1'b0;
      end
    end
  end
  
  always @(out) begin
    case (out)
      4'b0000: seg <= 7'b1000000; // 0
      4'b0001: seg <= 7'b1111001; // 1
      4'b0010: seg <= 7'b0100100; // 2
      4'b0011: seg <= 7'b0110000; // 3
      4'b0100: seg <= 7'b0011001; // 4
      4'b0101: seg <= 7'b0010010; // 5
      4'b0110: seg <= 7'b0000010; // 6
      4'b0111: seg <= 7'b1111000; // 7
      4'b1000: seg <= 7'b0000000; // 8
      4'b1001: seg <= 7'b0010000; // 9
      default: seg <= 7'b1111111; // display nothing
    endcase
  end

endmodule
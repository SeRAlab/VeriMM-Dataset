module top_module(
  input clk,
  input rst,
  input [3:0] bin,
  output reg [3:0] bcd
);always @ (posedge clk) begin
    if (rst) begin
      bcd <= 4'b0;
    end else begin
      case (bin)
        4'b0000: bcd <= 4'b0000;
        4'b0001: bcd <= 4'b0001;
        4'b0010: bcd <= 4'b0010;
        4'b0011: bcd <= 4'b0011;
        4'b0100: bcd <= 4'b0100;
        4'b0101: bcd <= 4'b0101;
        4'b0110: bcd <= 4'b0110;
        4'b0111: bcd <= 4'b0111;
        4'b1000: bcd <= 4'b1000;
        4'b1001: bcd <= 4'b1001;
        4'b1010: bcd <= 4'b0001;
        4'b1011: bcd <= 4'b0010;
        4'b1100: bcd <= 4'b0011;
        4'b1101: bcd <= 4'b0100;
        4'b1110: bcd <= 4'b0101;
        4'b1111: bcd <= 4'b0110;
      endcase
    end
  end

endmodule
module top_module(
  input clk,
  input rst,
  input [8:0] ctrl,
  output reg [3:0] td_mode
);always @(posedge clk, posedge rst) begin
    if (rst) begin
      td_mode <= 4'b0000;
    end else begin
      case (ctrl[8:6])
        3'b000: td_mode <= 4'b0000;
        3'b001: td_mode <= 4'b1000;
        3'b010: td_mode <= 4'b0100;
        3'b011: td_mode <= 4'b1100;
        3'b100: td_mode <= 4'b0010;
        3'b101: td_mode <= 4'b1010;
        3'b110: td_mode <= 4'b0101;
        3'b111: td_mode <= 4'b1111;
        default: td_mode <= 4'b0000;
      endcase
    end
  end

endmodule
module top_module(
  input clk,
  input reset,
  input [3:0] in,
  input [1:0] ctrl,
  output reg [3:0] out
);always @(posedge clk, negedge reset) begin
  if (!reset) begin
    out <= 4'b0;
  end else begin
    case (ctrl)
      2'b00: out <= in;
      2'b01: out <= {in[2:0], in[3]};
      2'b10: out <= {in[0], in[3:1]};
      2'b11: out <= {in[1:0], in[3:2]};
    endcase
  end
end

endmodule
module top_module(
  input clk,
  input rst,
  input [15:0] pushd,
  input push_en,
  input pop_en,
  output reg [15:0] top
);reg [3:0] sp; // stack pointer
  reg [15:0] mem [0:7]; // stack memory

  always @(posedge clk) begin
    if (rst) begin
      sp <= 0;
      top <= 0;
    end else begin
      if (push_en && sp < 8) begin
        mem[sp] <= pushd;
        sp <= sp + 1;
      end else if (pop_en && sp > 0) begin
        sp <= sp - 1;
      end
      top <= sp > 0 ? mem[sp-1] : 0;
    end
  end

endmodule
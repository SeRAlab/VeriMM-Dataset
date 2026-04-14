module top_module(
    input clk,
    input d,
    output reg q
);wire n1, n2, n3, n4;

  // Positive edge-triggered D flip-flop using NAND gates
  // Q(t+1) = D & ~CLK & Q(t)
  // ~Q(t+1) = ~D & ~CLK & ~Q(t)
  // Q(t+1) = ~(~D & ~CLK & ~Q(t))
  // ~Q(t+1) = ~(D & ~CLK & Q(t))

  assign n1 = ~(d & ~clk & q);
  assign n2 = ~(~d & ~clk & ~q);
  assign n3 = ~(n1 & ~clk & n4);
  assign n4 = ~(n2 & ~clk & n3);

  always @(posedge clk) begin
    q <= n3;
  end

endmodule
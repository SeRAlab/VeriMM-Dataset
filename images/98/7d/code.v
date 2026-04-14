module bidirectional_shift_register (
  input clk,
  input reset,
  input dir,
  input d,
  output reg [11:0] q);always @(posedge clk) begin
    if (reset)
        q <= 12'b000000000000;
    else if (dir)
        q <= {q[10:0], d};
    else
        q <= {d, q[11:1]};
end
endmodule
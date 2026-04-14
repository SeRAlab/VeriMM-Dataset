module top_module(
  input clk,
  input reset,
  input [31:0] data,
  input load,
  input ena,
  input [4:0] amount,
  output reg [31:0] q
);always @(posedge clk, posedge reset) begin
  if (reset) begin
    q <= 0;
  end else if (load) begin
    q <= data;
  end else if (ena) begin
    if (amount[4]) begin
      q <= {32{data[31]}};
    end else if (amount != 0) begin
      if (amount[3]) q[31] <= data[31];
      if (amount[2]) q[30:0] <= q[31:1];
      if (amount[1]) q[31:1] <= q[30:0];
      if (amount[0]) q[0] <= data[0];
    end
  end
end

endmodule
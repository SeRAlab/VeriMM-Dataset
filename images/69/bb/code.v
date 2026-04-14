module top_module(
  input D,
  input S,
  input R,
  input CLK,
  output reg Q,   // Change made here to specify Q as a reg type
  output QN
);always @(posedge CLK or negedge R or negedge S) begin
  if (!R) begin
    Q <= 1'b0;
  end else if (!S) begin
    Q <= 1'b1;
  end else begin
    Q <= D;
  end
end

assign QN = ~Q;

endmodule
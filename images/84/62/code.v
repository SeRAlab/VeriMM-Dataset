module top_module(
  input clk,
  input reset_n,
  input din,
  output dout
);parameter depth = 2;

reg [depth-1:0] ff;
reg [depth-1:0] ff_next;

always @(posedge clk or negedge reset_n) begin
  if (~reset_n) begin
    ff <= {depth{1'b0}};
  end else begin
    ff <= {ff[depth-2:0], din};
  end
end

assign dout = ff[depth-1];

endmodule
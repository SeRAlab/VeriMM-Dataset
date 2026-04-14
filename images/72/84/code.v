module top_module(CLK, D, RST, EN, Q);input CLK, D, RST, EN;
output Q;
reg Q;

always @(posedge CLK) begin
  if (RST == 1'b1) begin
    Q <= 1'b0;
  end else if (EN == 1'b1) begin
    Q <= D;
  end
end

endmodule
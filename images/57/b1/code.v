module top_module(
  input clk, CEN, WE,
  input [2:0] AddrA,
  input [7:0] DI,
  output reg [7:0] DO
);reg [7:0] Regs [0:7];

always @(posedge clk) begin
  if (CEN) begin
    if (WE) Regs[AddrA] <= DI;
    DO <= Regs[AddrA];
  end else begin
    DO <= Regs[AddrA];
  end
end

endmodule
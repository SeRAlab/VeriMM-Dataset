module top_module(
  input clk,
  input dbusWire1,
  input DselectWire2,
  input dbusWire2,
  input DselectWire3,
  output reg dbus
);reg latch1;
reg latch2;
reg latch3;

always @(posedge clk) begin
  latch1 <= dbusWire1;
end

always @(posedge clk) begin
  if (DselectWire2) begin
    latch2 <= latch1;
  end else begin
    latch2 <= dbusWire1;
  end
end

always @(posedge clk) begin
  if (DselectWire3) begin
    latch3 <= latch2;
  end else begin
    latch3 <= latch2;
  end
end

assign dbus = latch3;

endmodule
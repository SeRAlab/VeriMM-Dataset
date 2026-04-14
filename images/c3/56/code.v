module POR (
  input VDD,
  output RST
);

parameter t = 10; // time it takes for power supply to stabilize (in ns)

reg [31:0] count; // counter to keep track of time
reg POR_active; // flag to indicate if POR is active

always @(posedge VDD) begin
  count <= 0; // reset counter
  POR_active <= 1; // set POR flag
end

always @(posedge clk) begin
  if (POR_active && (count < t)) begin
    RST <= 1; // assert reset signal
    count <= count + 1; // increment counter
  end else begin
    RST <= 0; // de-assert reset signal
    POR_active <= 0; // clear POR flag
  end
end

endmodule
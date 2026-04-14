module top_module(
  output reg clk
);parameter freq = 1000000; // frequency of the crystal oscillator in Hz

reg [31:0] count = 0; // counter to keep track of clock cycles

always @(posedge count[31]) begin
  if (count == (freq/2) - 1) begin
    count <= 0;
    clk <= ~clk;
  end else begin
    count <= count + 1;
  end
end

endmodule
module top_module(
  input [3:0] D,
  input CLK,
  input RST,
  output reg [9:0] W
);parameter R = 100; // maximum resistance value
parameter N = 16; // number of steps in digital potentiometer

always @(posedge CLK) begin
  if (RST) begin
    W <= 10'b0; // reset resistance value to 0
  end else begin
    W <= {10{D}} * R / (N-1); // calculate resistance value
  end
end

endmodule
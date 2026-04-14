module top_module(
  input [7:0] wiper,
  input inc,
  input dec,
  output reg [7:0] out
);parameter r = 1000; // total resistance of the potentiometer in ohms

reg [7:0] wiper_pos = 0; // define a wiper position register

always @ (posedge inc or posedge dec) begin
  if (inc) begin
    wiper_pos <= wiper_pos + 1; // increment wiper position register
  end else if (dec) begin
    wiper_pos <= wiper_pos - 1; // decrement wiper position register
  end
end

assign out = (wiper_pos * r) / 255; // compute resistance between fixed terminals

endmodule
module top_module(
  input ctrl,
  output reg vout
);parameter voltage_level = 3.3; // voltage level of the output signal in volts. Can be changed according to requirements.

reg [15:0] voltage_level_int;

initial begin
  voltage_level_int = voltage_level * 1000; // Convert voltage level to an integer value (in millivolts)
end

always @(*) begin
  if (ctrl) begin
    vout = voltage_level_int;
  end
  else begin
    vout = 0;
  end
end


endmodule
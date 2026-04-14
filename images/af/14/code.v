module top_module(
  input CS,
  input SDI,
  input CLK,
  output reg SDO
);parameter n = 8; // number of bits in the digital potentiometer

reg [n-1:0] resistance = 0; // initialize resistance to 0

always @(posedge CLK) begin
  if (CS == 1'b0) begin // digital potentiometer is enabled
    resistance <= {SDI, resistance[n-2:1]}; // shift in new data
  end
end

assign SDO = resistance * 1000; // convert resistance to ohms and output

endmodule
module top_module(
  input analog_in,
  output reg [7:0] digital_out
);parameter vref = 5; // reference voltage
parameter res = 8; // resolution of ADC (in bits)

reg [7:0] count;

always @ (posedge analog_in) begin
  if (analog_in > (vref/2)) begin
    count <= {1'b1, {res-1{1'b1}}}; // positive voltage
  end else begin
    count <= {1'b0, {res-1{1'b0}}}; // negative voltage
  end
end

assign digital_out = count;

endmodule
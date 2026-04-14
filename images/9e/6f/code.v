module top_module(
  input clk, // clock signal
  input reset, // reset signal
  input data_in, // input data signal
  output reg data_out // output data signal
);parameter N = 4; // number of clock cycles to delay the input signal by

reg [N-1:0] buffer; // buffer to store delayed data

always @(posedge clk) begin
  if (reset) begin
    buffer <= 0; // reset buffer
    data_out <= 0; // set output to 0
  end
  else begin
    buffer <= {buffer[N-2:0], data_in}; // shift data into buffer
    data_out <= buffer[N-1]; // output delayed data
  end
end

endmodule
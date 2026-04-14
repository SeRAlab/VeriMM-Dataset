module top_module(
  input analog_in,
  input clk,           // added missing clock input
  output reg [n-1:0] digital_out
);parameter n = 8; // number of bits in digital output signal
parameter fs = 100; // sampling frequency of analog input signal in Hz
parameter fclk = 10e6; // clock frequency of ADC in Hz

reg [n-1:0] approx_out; // output of successive approximation algorithm
reg [n-1:0] threshold; // threshold for successive approximation algorithm
reg [n-1:0] temp_out; // temporary output for successive approximation algorithm
reg [n-1:0] code; // digital output code
reg [n-1:0] count; // counter for successive approximation algorithm
reg clk_div; // clock divider for ADC clock

assign digital_out = code;

always @ (posedge clk_div) begin
  // sample analog input signal
  approx_out = (analog_in >= threshold) ? 1'b1 : 1'b0;
  
  // update threshold for next iteration
  if (approx_out == 1'b1) begin
    threshold = threshold + (1 << (n - count - 1));
  end else begin
    threshold = threshold - (1 << (n - count - 1));
  end
  
  // update temporary output
  temp_out[count] = approx_out;
  
  // increment counter
  count = count + 1;
  
  // check if finished
  if (count == n) begin
    code = temp_out; // update digital output code
    count = 0; // reset counter
    threshold = (1 << (n - 1)); // reset threshold
  end
end

always @ (posedge clk) begin
  // generate ADC clock
  clk_div = ~clk_div;
end

initial begin
  // Initialize signals
  threshold = 0;
  count = 0;
  clk_div = 0;
end

endmodule
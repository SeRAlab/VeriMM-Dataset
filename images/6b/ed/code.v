module top_module(
  input clk,
  input in,
  output reg out // changed output to reg
);parameter t = 10; // minimum duration of a valid signal (in clock cycles)
  
  reg [3:0] count = 0; // counter to count clock cycles
  reg prev_in = 0; // previous value of input signal
  
  always @(posedge clk) begin
    if (in != prev_in) begin // input signal has changed
      count <= 0; // reset counter
    end else begin // input signal has not changed
      if (count < t) begin // wait for t clock cycles
        count <= count + 1;
      end else begin // t clock cycles have passed
        out <= in; // update output signal
      end
    end
    prev_in <= in; // update previous value of input signal
  end
  
endmodule
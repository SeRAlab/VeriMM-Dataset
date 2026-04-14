module top_module(
  input reset,
  input clk,
  output reg reset_release // Change to reg type
);parameter delay = 10; // delay period in clock cycles

reg [3:0] counter; // 4-bit counter to count the delay period

always @(posedge clk) begin
  if (reset) begin
    counter <= 0; // reset the counter
    reset_release <= 0; // hold the circuit in reset
  end
  else begin
    if (counter < delay) begin
      counter <= counter + 1; // increment the counter
      reset_release <= 0; // hold the circuit in reset
    end
    else begin
      reset_release <= 1; // release the circuit from reset
    end
  end
end

endmodule
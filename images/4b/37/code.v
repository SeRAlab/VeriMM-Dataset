module top_module(
  input clk,
  output reg out
);parameter voltage = 1.8; // voltage level of the output signal

// clock divider
reg [15:0] counter = 0;

always @(posedge clk) begin
  if (counter == 0) begin
    counter <= 499; // divide clock by 500
    out <= voltage; // assign constant voltage to out
  end
  else begin
    counter <= counter - 1;
  end
end

endmodule
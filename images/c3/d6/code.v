module clk_delay_buffer (
  input clk_in,
  input reset,
  output reg clk_out
);

  // Counter to count 5 ns
  reg [22:0] counter = 0;

  always @(posedge clk_in, posedge reset) begin
    if (reset) begin
      clk_out <= 1'b0;
      counter <= 0;
    end else begin
      if (counter == 23'd249) begin
        counter <= 0;
        clk_out <= ~clk_out;
      end else begin
        counter <= counter + 1;
      end
    end
  end

endmodule
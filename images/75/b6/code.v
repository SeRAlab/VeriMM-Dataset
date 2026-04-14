module top_module(
  input input_clk,
  input [31:0] delay,
  output output_clk
);parameter clk_period = 1000; // period of input clock (in picoseconds)

reg [31:0] counter = 0;
reg [31:0] delay_cycles = delay / clk_period;

wire delayed_clk;
assign delayed_clk = counter >= delay_cycles ? input_clk : 1'b0;

always @(posedge delayed_clk) begin
  counter <= 0;
end

always @(posedge input_clk) begin
  if (counter < delay_cycles) begin
    counter <= counter + 1;
  end
end

assign output_clk = delayed_clk;

endmodule
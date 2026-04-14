module top_module(
  input clk,
  input in,
  input [7:0] delay,
  output reg out
);reg [7:0] counter;

always @(posedge clk) begin
  if (in != counter[7:0]) begin
    counter <= 0;
    out <= 0;
  end
  else if (counter == delay) begin
    out <= in;
  end
  counter <= counter + 1;
end

endmodule
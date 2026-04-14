module top_module(
  input clk,
  input bouncy,
  output debounced
);reg [18:0] counter;
reg d1, d2, d3;
assign debounced = d1 & d2 & d3;

always @(posedge clk) begin
  if (&counter) begin
    counter <= 0;
    d1 <= bouncy;
    d2 <= d1;
    d3 <= d2;
  end else
    counter <= counter + 1'b1;
end

endmodule
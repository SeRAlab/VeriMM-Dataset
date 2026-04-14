module top_module(
  input in,
  output reg out
);parameter n = 4; // number of bits used to represent the counter
parameter max_count = 10; // maximum value for the counter

reg [n-1:0] count;
reg last_in;

always @(posedge in) begin
  if (in != last_in) begin
    count <= 0;
  end else if (count == max_count-1) begin
    out <= in;
  end else begin
    count <= count + 1;
  end
  last_in <= in;
end

endmodule
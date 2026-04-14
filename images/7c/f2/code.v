module top_module(
  input vdd,
  output reg rst
);parameter t = 100; // reset time in ns
  reg prev_vdd;
  reg [31:0] counter;

  always @(posedge vdd) begin
    if (prev_vdd == 1'b0) begin
      rst <= 1'b1;
      counter <= 0;
    end else if (counter < t) begin
      counter <= counter + 1;
    end else begin
      rst <= 1'b0;
    end
    prev_vdd <= vdd;
  end

endmodule
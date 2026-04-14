module top_module(
  input rst_n, clock, d_in,
  output found
);reg [2:0] bits;

  always @(posedge clock) begin
    if (!rst_n)
      bits <= 0; 
    else if (found) begin
      bits[2:1] <= 0;
      bits[0] <= d_in;
    end
    else begin
      bits <= bits << 1;
      bits[0] <= d_in;
    end
  end

  assign shift_out = bits[2];
  assign found = ( bits[0] && (!bits[1]) && bits[2] );

endmodule
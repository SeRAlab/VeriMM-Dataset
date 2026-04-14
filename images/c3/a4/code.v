module bin2bcd(
  input [3:0] bin_in,
  input clk,
  output reg [3:0] bcd_out1,
  output reg [3:0] bcd_out2
);

  reg [3:0] bcd[1:2];
  integer i;

  always @(posedge clk) begin
    // Convert binary to BCD
    for (i = 1; i <= 2; i = i + 1) begin
      bcd[i] = 0;
    end

    for (i = 0; i <= 3; i = i + 1) begin
      if (bin_in[i] >= 5) begin
        bcd[1][i] = 1;
        bcd[2][i] = bin_in[i] - 5;
      end else begin
        bcd[2][i] = bin_in[i];
      end
    end

    // Output BCD digits
    bcd_out1 <= bcd[1];
    bcd_out2 <= bcd[2];
  end

endmodule
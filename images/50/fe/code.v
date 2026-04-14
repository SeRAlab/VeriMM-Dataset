module top_module(
  input [3:0] bin,
  output [15:0] bcd
);// Define variables
  reg [3:0] temp_bin;
  reg [15:0] temp_bcd;
  integer i;

  // Convert binary to BCD using double-dabble algorithm
  always @(*) begin
    temp_bin = bin;
    temp_bcd = 0;
    for (i = 0; i < 4; i = i + 1) begin
      temp_bcd = temp_bcd << 4;
      if (temp_bin >= 5) begin
        temp_bcd[i*4+3] = 1;
        temp_bin = temp_bin - 5;
      end
      if (temp_bin >= 2) begin
        temp_bcd[i*4+2] = 1;
        temp_bin = temp_bin - 2;
      end
      if (temp_bin >= 1) begin
        temp_bcd[i*4+1] = 1;
        temp_bin = temp_bin - 1;
      end
      temp_bin = temp_bin << 1;
    end
  end

  // Assign BCD output
  assign bcd = temp_bcd;

endmodule
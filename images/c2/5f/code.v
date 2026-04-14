module simple_adder(
  input [7:0] a,
  input [7:0] b,
  input cin,
  output [7:0] sum,
  output cout
);

  wire [8:0] temp_sum;
  assign temp_sum = {1'b0, a} + {1'b0, b} + cin;
  
  // Check if overflow occurred
  always @(*) begin
    if (temp_sum[8] == 1) begin
      if (temp_sum[7] == 1) begin
        sum = -128;
      end else begin
        sum = 127;
      end
      cout = 1;
    end else begin
      sum = temp_sum[7:0];
      cout = 0;
    end
  end

endmodule
module top_module(A, B, C);input [7:0] A, B;
  output C;

  wire [7:0] difference;
  wire [7:0] not_difference;
  wire [7:0] temp_not_difference;
  wire [7:0] temp_difference;

  assign difference = A - B;
  assign not_difference = ~difference;

  assign temp_not_difference = {not_difference[7], not_difference[7:1]};
  assign temp_difference = {difference[7], difference[7:1]};

  assign C = temp_not_difference[7] & temp_difference[7];

endmodule
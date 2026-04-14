module comparator_8bit (
  input [7:0] in1,
  input [7:0] in2,
  output reg match
);

  reg [7:0] temp;
  integer i;

  always @* begin
    match = 1;
    for (i = 0; i < 8; i = i + 1) begin
      temp[i] = (in1[i] == in2[i]);
      match = match & temp[i];
    end
  end

endmodule

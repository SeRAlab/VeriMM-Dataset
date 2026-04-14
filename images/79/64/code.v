module priority_encoder (
  input [3:0] a,
  output reg [1:0] y,
  output reg valid
);

  always @(*) begin
    valid = 1;
    if (a[3]) y = 2'b11;
    else if (a[2]) y = 2'b10;
    else if (a[1]) y = 2'b01;
    else if (a[0]) y = 2'b00;
    else valid = 0;
  end

endmodule
module top_module(
  input [7:0] A,
  input [7:0] B,
  output reg [15:0] result
);reg [7:0] temp;
  integer i, j;

  always @* begin
    result = 0;
    for (i = 0; i < 8; i = i + 1) begin
      temp = 0;
      for (j = 0; j < 8; j = j + 1) begin
        if ((B[j] == 1) && (A[i] == 1)) begin
          temp = temp + (1 << (i + j));
        end
      end
      result = result + temp;
    end
  end

endmodule
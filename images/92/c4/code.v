module top_module(input [1:0] A, input [1:0] B, input enable, output reg [3:0] result);always @(*) begin
    if (enable == 1'b0) begin
      result <= 4'b0;
    end
    else begin
      result <= (A[0] & B[0]) << 0
              + (A[1] & B[0]) << 1
              + (A[0] & B[1]) << 1
              + (A[1] & B[1]) << 2;
    end
  end

endmodule
module fibonacci(
  input clk,
  input reset,
  output reg [31:0] fib_num
);

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      fib_num <= 0;
    end else if (fib_num == 0) begin
      fib_num <= 1;
    end else begin
      fib_num <= fib_num + (fib_num - 1);
    end
  end

endmodule
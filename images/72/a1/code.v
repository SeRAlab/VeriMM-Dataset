module verified_fibonacci_generator 
(
  input rst_n,
  input clk,

  output reg [5:0] fib
);

  reg [5:0] prev_fib;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      fib <= 6'b000000;
      prev_fib <= 6'b000001;
    end 

	else 
	begin
      fib <= fib + prev_fib;
      prev_fib <= fib;
    end
  end

endmodule
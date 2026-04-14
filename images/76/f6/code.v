module Fibonacci_32(
   input                clk ,
   input                rst_n,
 
   output reg [31:0]     Q  
);
    reg [31:0] fib1, fib2;

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            fib1 <= 32'd0;
            fib2 <= 32'd1;
            Q <= 32'd1;
        end else begin
            Q <= fib1 + fib2;
            fib1 <= fib2;
            fib2 <= Q;
        end
    end
endmodule
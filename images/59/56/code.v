module fibonacci_generator (
    input clk,
    input rst,
    input en,
    output reg [7:0] fib1,
    output reg [7:0] fib2);

    always @(posedge clk) begin
        if (rst) begin
            fib1 <= 8'b1;
            fib2 <= 8'b1;
        end else if (en) begin
            fib2 <= fib2 + fib1;
            fib1 <= fib2;
        end
    end
endmodule
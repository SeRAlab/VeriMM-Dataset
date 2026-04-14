module Fibonacci_12(
   input                clk,
   input                rst_n,
   output reg [11:0]    Q  
);
    reg [11:0] prev1, prev2;
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            prev1 <= 12'd0;
            prev2 <= 12'd1;
            Q <= 12'd0;
        end
        else begin
            Q <= prev1 + prev2;
            prev1 <= prev2;
            prev2 <= Q;
        end
    end
endmodule
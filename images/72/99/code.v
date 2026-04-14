module top_module(
    input clk,
    input rst,
    input [7:0] num1,
    input [7:0] num2,
    input [1:0] op,
    output reg [15:0] res,
    output reg flag
);reg [7:0] a;
    reg [7:0] b;
    reg [15:0] temp_res;
    
    always @(posedge clk) begin
        if (rst) begin
            res <= 0;
            flag <= 0;
        end else begin
            a <= num1;
            b <= num2;
            
            case (op)
                2'b00: temp_res <= a + b;
                2'b01: temp_res <= a - b;
                2'b10: temp_res <= a * b;
                2'b11: temp_res <= a / b;
            endcase
            
            res <= temp_res;
            flag <= (temp_res < 0);
        end
    end
    
endmodule
module top_module(input [7:0] a, input [7:0] b, input cin, input rst, input clk, output [7:0] sum, output cout);reg [7:0] sum_reg;
    wire [8:0] temp_sum;
    
    assign temp_sum = {1'b0, a} + {1'b0, b} + cin;
    assign cout = temp_sum[8];
    always @(posedge clk) begin
        if (rst) begin
            sum_reg <= 8'b0;
        end else begin
            sum_reg <= temp_sum[7:0];
        end
    end
    assign sum = sum_reg;
endmodule
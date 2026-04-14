module top_module(
    input clk,
    input reset,
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);reg [3:0] temp_sum;
    reg temp_cout;
    
    always @(posedge clk) begin
        if (reset) begin
            temp_sum <= 4'b0000;
            temp_cout <= 1'b0;
        end else begin
            temp_sum <= a + b + cin;
            temp_cout <= temp_sum[4];
        end
    end
    
    assign sum = temp_sum;
    assign cout = temp_cout;
    
endmodule
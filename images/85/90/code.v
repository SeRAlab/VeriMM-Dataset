module top_module(clk, rst, x, y, sum);input clk, rst;
    input x, y;
    output reg sum;

    reg sc;

    
    wire hsum1, hco1;
    assign hsum1 = y ^ sc;
    assign hco1 = y & sc;

    wire hsum2, hco2;
    assign hsum2 = x ^ hsum1;
    assign hco2 = x & hsum1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            
            sum <= 1'b0;
            sc <= 1'b0;
        end
        else begin
            
            sum <= hsum2;
            sc <= hco1 ^ hco2;
        end
    end
endmodule
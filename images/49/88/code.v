module top_module(clk, reset, a, b, cin, sum, cout);input clk, reset;
    input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output cout;

    reg [3:0] sum_reg;
    reg cout_reg;

    always @(posedge clk) begin
        if (reset) begin
            sum_reg <= 4'b0;
            cout_reg <= 1'b0;
        end else begin
            sum_reg <= a + b + cin;
            cout_reg <= (sum_reg[4] == 1) ? 1'b1 : 1'b0;
        end
    end

    assign sum = sum_reg;
    assign cout = cout_reg;

endmodule
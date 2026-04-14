module top_module(clk, rst_n, A, B, Cin, Sum, Cout);input clk;
    input rst_n;
    input [15:0] A, B;
    input Cin;
    output [15:0] Sum;
    output Cout;

    reg [15:0] sum_reg;
    reg Cout_reg;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            sum_reg <= 16'd0;
            Cout_reg <= 1'b0;
        end
        else begin
            sum_reg <= A + B + Cin;
            Cout_reg <= (sum_reg[16] == 1) ? 1'b1 : 1'b0;
        end
    end

    assign Sum = sum_reg;
    assign Cout = Cout_reg;
endmodule
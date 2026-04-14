module top_module(
    input clk,
    input reset_n,
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);reg [3:0] S_reg;
    reg Cout_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            S_reg <= 4'b0;
            Cout_reg <= 1'b0;
        end else begin
            {Cout_reg, S_reg} <= A + B + Cin;
        end
    end

    assign Cout = Cout_reg;
    assign S = S_reg;

endmodule
module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input reset,
    input Clk,
    input Clk_180,
    output [3:0] S,
    output Cout
);reg [3:0] S_reg;
reg Cout_reg;

always @(posedge Clk, posedge reset) begin
    if (reset) begin
        S_reg <= 4'b0;
        Cout_reg <= 1'b0;
    end else begin
        S_reg <= A + B + Cin;
        Cout_reg <= ((A[3] & B[3]) | (Cin & (A[3] | B[3])));
    end
end

assign S = S_reg;
assign Cout = Cout_reg;

endmodule
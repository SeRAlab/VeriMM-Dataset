module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    input clk,                // Added clk input
    output reg [3:0] sum,
    output reg cout
);reg [3:0] a_reg, b_reg, sum_reg;
reg cin_reg;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    cin_reg <= cin;
    sum_reg <= a_reg + b_reg + cin_reg; // Sum calculation should consider the registered values
end

always @(posedge clk) begin
    sum <= sum_reg;
    cout <= (a_reg + b_reg + cin_reg) >> 4; // Calculate cout correctly
end

endmodule
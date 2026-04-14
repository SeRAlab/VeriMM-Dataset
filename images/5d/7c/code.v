module top_module(
    input [7:0] A,
    input [7:0] B,
    input CIN,
    input SUB,
    input clk,           // Added clk input
    output reg [7:0] SUM,
    output reg OVF
);reg [7:0] A_reg, B_reg, SUM_reg;
reg CIN_reg, SUB_reg;
reg [8:0] SUM_temp;
reg OVF_reg;

always @ (posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    CIN_reg <= CIN;
    SUB_reg <= SUB;
end

always @ (posedge clk) begin
    if (SUB_reg) begin
        SUM_temp <= A_reg - B_reg - CIN_reg;
    end else begin
        SUM_temp <= A_reg + B_reg + CIN_reg;
    end
end

always @ (posedge clk) begin
    SUM_reg <= SUM_temp[7:0];
    OVF_reg <= SUM_temp[8];
end

assign SUM = SUM_reg;
assign OVF = OVF_reg;

endmodule
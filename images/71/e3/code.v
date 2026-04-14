module top_module(
    input [31:0] A,
    input clk,          // Added clk signal as input
    output reg [5:0] B
);reg [31:0] A_reg [0:2];
reg [31:0] A_reg_p [0:2];
reg [5:0] B_reg [0:2];

integer i;

always @(*) begin
    A_reg[0] = A;
    for (i = 1; i < 3; i = i + 1) begin
        A_reg[i] = A_reg_p[i-1];
    end
end

always @(posedge clk) begin
    A_reg_p[0] <= A_reg[0];
    for (i = 1; i < 3; i = i + 1) begin
        A_reg_p[i] <= A_reg[i-1];
    end
end

always @(posedge clk) begin
    B_reg[0] <= B;
    for (i = 1; i < 3; i = i + 1) begin
        B_reg[i] <= B_reg[i-1];
    end
end

always @(posedge clk) begin
    if (A_reg_p[2][0]) begin
        B <= B_reg[2] + 1;
    end else begin
        B <= B_reg[2];
    end
end

endmodule
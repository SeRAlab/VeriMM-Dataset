module top_module(
    input clk,               // Added clk input
    input [15:0] A,
    input [15:0] B,
    output reg [31:0] P
);reg [15:0] a_reg;
reg [15:0] b_reg;
reg [15:0] pp1_reg;
reg [15:0] pp2_reg;
reg [15:0] pp3_reg;
reg [15:0] pp4_reg;
wire [15:0] pp1;          // Added wire declarations
wire [15:0] pp2;          // Added wire declarations
wire [15:0] pp3;          // Added wire declarations
wire [15:0] pp4;          // Added wire declarations

always @(posedge clk) begin
    a_reg <= A;
    b_reg <= B;
end

// Stage 1
assign pp1 = a_reg[0] ? b_reg : 16'b0;  // Use 16'b0 instead of 0
always @(posedge clk) begin
    pp1_reg <= pp1;
end

// Stage 2
assign pp2 = a_reg[1] ? {b_reg[14:0], 1'b0} : 16'b0;  // Use 16'b0 instead of 0
always @(posedge clk) begin
    pp2_reg <= pp2;
end

// Stage 3
assign pp3 = a_reg[2] ? {b_reg[13:0], 2'b00} : 16'b0;  // Use 16'b0 instead of 0
always @(posedge clk) begin
    pp3_reg <= pp3;
end

// Stage 4
assign pp4 = a_reg[3] ? {b_reg[12:0], 3'b000} : 16'b0;  // Use 16'b0 instead of 0
always @(posedge clk) begin
    pp4_reg <= pp4;
end

always @(posedge clk) begin
    P <= pp1_reg + pp2_reg + pp3_reg + pp4_reg;
end

endmodule
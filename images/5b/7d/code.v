module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,       // Added clock input here
    output reg [7:0] P
);reg [3:0] A_reg;
reg [3:0] B_reg;
reg [7:0] P_reg1;   // Changed the size to 8 bits for proper multiplication
reg [7:0] P_reg2;   // Changed the size to 8 bits for proper multiplication

// Register the inputs on clock edge
always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

// Pipeline stage 1
always @(posedge clk) begin
    P_reg1 <= A_reg[0] ? {4'b0, B_reg} : 8'b0; // Ensured correct bit width for result
end

// Pipeline stage 2
always @(posedge clk) begin
    P_reg2 <= {P_reg1[6:0], 1'b0} + (A_reg[1] ? {B_reg, 2'b0} : 8'b0); // Changed sizes
end

// Pipeline stage 3
always @(posedge clk) begin
    P <= {P_reg2[6:0], 1'b0} + (A_reg[2] ? {B_reg, 3'b0} : 8'b0); // Changed sizes
end

endmodule
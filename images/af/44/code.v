module top_module(
    input clk, reset, enable,
    input [3:0] A, B,
    output [3:0] S,
    output Cout
);reg [3:0] S_reg; // register for storing the sum
    reg Cout_reg; // register for storing the carry-out
    reg [3:0] A_reg, B_reg; // registers for storing the inputs
    
    always @(posedge clk) begin
        if (reset) begin
            S_reg <= 4'b0;
            Cout_reg <= 1'b0;
            A_reg <= 4'b0; // Initialize A_reg on reset
            B_reg <= 4'b0; // Initialize B_reg on reset
        end
        else if (enable) begin
            A_reg <= A; // Update A_reg based on input A
            B_reg <= B; // Update B_reg based on input B
            S_reg <= A_reg + B_reg;
            Cout_reg <= (A_reg[3] & B_reg[3]) | (A_reg[3] & ~S_reg[3]) | (B_reg[3] & ~S_reg[3]);
        end
    end
    
    assign S = S_reg;
    assign Cout = Cout_reg;
    
endmodule
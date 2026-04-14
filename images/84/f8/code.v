module top_module(
    input clk,
    input [15:0] A,
    input [3:0] B,
    input S,
    output reg [15:0] P
);reg [15:0] A_reg;
reg [3:0] B_reg;
reg S_reg;
reg [15:0] P_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    S_reg <= S;
end

always @(posedge clk) begin
    if (B_reg != 0) begin
        if (S_reg == 0) begin
            // Logical left shift
            P_reg <= A_reg << B_reg; //Shift left
        end else begin
            // Logical right shift
            P_reg <= A_reg >> B_reg; //Shift right
        end
    end else begin
        P_reg <= A_reg;
    end
end

assign P = P_reg;

endmodule
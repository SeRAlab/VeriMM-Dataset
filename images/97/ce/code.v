module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,           // Added clk input
    output reg EQ,      // Changed to reg to match usage in always blocks
    output reg GT,      // Changed to reg to match usage in always blocks
    output reg LT       // Changed to reg to match usage in always blocks
);reg [3:0] A_reg;
reg [3:0] B_reg;
reg [1:0] stage;

always @(*) begin
    case(stage)
        0: begin
            A_reg = A;
            B_reg = B;
        end
        1: begin
            A_reg = A_reg;
            B_reg = B_reg;
        end
    endcase
end

always @(posedge clk) begin
    if (stage == 1) begin
        stage <= 0;
    end else begin
        stage <= 1;
    end
end

always @(*) begin
    EQ = (A_reg == B_reg);
    GT = (A_reg > B_reg);
    LT = (A_reg < B_reg);
end

endmodule
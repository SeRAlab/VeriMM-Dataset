module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,      // Added the clk input
    output EQ,
    output GT,
    output LT
);reg [3:0] A_reg, B_reg;
reg [2:0] stage;

assign EQ = (A == B);
assign GT = (A > B);
assign LT = (A < B);

always @(posedge clk) begin
    case(stage)
        0: begin
            A_reg <= A;
            B_reg <= B;
            stage <= 1;
        end
        1: begin
            A_reg <= A_reg;
            B_reg <= B_reg;
            stage <= 2;
        end
        2: begin
            A_reg <= A_reg;
            B_reg <= B_reg;
            stage <= 3;
        end
        3: begin
            A_reg <= A_reg;
            B_reg <= B_reg;
            stage <= 0;
        end
    endcase
end

endmodule
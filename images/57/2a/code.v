module top_module(
    input clk,           // Added clk input
    input [3:0] A,
    input [3:0] B,
    input [2:0] OP,
    output reg [3:0] Y
);reg [3:0] A_reg, B_reg, Y_reg;
reg [1:0] stage;

always @(posedge clk) begin
    case (stage)
        0: begin
            A_reg <= A;
            B_reg <= B;
            case (OP)
                3'b000: Y_reg <= A_reg + B_reg;
                3'b001: Y_reg <= A_reg - B_reg;
                3'b010: Y_reg <= A_reg & B_reg;
                3'b011: Y_reg <= A_reg | B_reg;
                3'b100: Y_reg <= A_reg ^ B_reg;
            endcase
            stage <= 1;
        end
        1: begin
            Y <= Y_reg;
            stage <= 0;
        end
    endcase
end

endmodule
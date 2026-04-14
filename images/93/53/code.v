module top_module(
    input [7:0] A,
    input [7:0] B,
    input clk,
    output reg EQ,
    output reg GT
);reg [7:0] A_reg, B_reg;
reg [2:0] stage;

always @(posedge clk) begin
    case(stage)
        0: begin
            A_reg <= A;
            B_reg <= B;
            stage <= 1;
        end
        1: begin
            if(A_reg == B_reg) begin
                EQ <= 1;
                GT <= 0;
            end
            else if(A_reg > B_reg) begin
                EQ <= 0;
                GT <= 1;
            end
            else begin
                EQ <= 0;
                GT <= 0;
            end
            stage <= 2;
        end
        2: begin
            EQ <= 0;
            GT <= 0;
            stage <= 0;
        end
    endcase
end

endmodule
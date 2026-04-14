module top_module(
    input [15:0] A,
    input [15:0] B,
    input clk,                // Added clk input
    output reg result
);reg [15:0] A_reg, B_reg;
reg [3:0] stage;

always @(*) begin
    case(stage)
        0: begin
            A_reg = A;
            B_reg = B;
        end
        1: begin
            A_reg = A_reg >> 1;
            B_reg = B_reg >> 1;
        end
        2: begin
            A_reg = A_reg >> 2;
            B_reg = B_reg >> 2;
        end
        3: begin
            A_reg = A_reg >> 4;
            B_reg = B_reg >> 4;
        end
        4: begin
            A_reg = A_reg >> 8;
            B_reg = B_reg >> 8;
        end
    endcase
end

always @(posedge clk) begin
    if (stage == 4) begin
        result <= (A_reg <= B_reg);
        stage <= 0;
    end else begin
        stage <= stage + 1;
    end
end

endmodule
module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input clk,             // Added clock input
    output reg Y0,
    output reg Y1
);reg [3:0] A_reg, B_reg, C_reg, D_reg;
reg [1:0] stage;

always @(posedge clk) begin
    case (stage)
        0: begin
            A_reg <= A;
            B_reg <= B;
            C_reg <= C;
            D_reg <= D;
            Y0 <= 0;
            Y1 <= 0;
            stage <= 1;
        end
        1: begin
            if (A_reg[3] || B_reg[3]) begin
                Y0 <= 1;
                Y1 <= 0;
            end else if (C_reg[3] || D_reg[3]) begin
                Y0 <= 0;
                Y1 <= 1;
            end else begin
                Y0 <= 0;
                Y1 <= 0;
            end
            stage <= 2;
        end
        2: begin
            if (A_reg[2] || B_reg[2]) begin
                Y0 <= 1;
                Y1 <= 0;
            end else if (C_reg[2] || D_reg[2]) begin
                Y0 <= 0;
                Y1 <= 1;
            end else begin
                Y0 <= 0;
                Y1 <= 0;
            end
            stage <= 3;
        end
        3: begin
            if (A_reg[1] || B_reg[1]) begin
                Y0 <= 1;
                Y1 <= 0;
            end else if (C_reg[1] || D_reg[1]) begin
                Y0 <= 0;
                Y1 <= 1;
            end else begin
                Y0 <= 0;
                Y1 <= 0;
            end
            stage <= 4;
        end
        4: begin
            if (A_reg[0] || B_reg[0]) begin
                Y0 <= 1;
                Y1 <= 0;
            end else if (C_reg[0] || D_reg[0]) begin
                Y0 <= 0;
                Y1 <= 1;
            end else begin
                Y0 <= 0;
                Y1 <= 0;
            end
            stage <= 0;
        end
    endcase
end

endmodule
module top_module(
    input clk,
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
);reg [3:0] A_reg;
reg [3:0] B_reg;
reg [2:0] counter;
reg [7:0] P_reg;
reg [1:0] state;

always @(*) begin
    A_reg = A;
    B_reg = B;
    counter = 3;
    P_reg = 0;
    state = 0;
end

always @(posedge clk) begin
    case (state)
        0: begin
            if (B_reg[0] == 1) begin
                P_reg = P_reg + (A_reg << 0);
            end
            state = 1;
        end
        1: begin
            if (counter == 0) begin
                state = 3;
            end else begin
                if (B_reg[0] == 0 && B_reg[1] == 0) begin
                    state = 2;
                end else if (B_reg[0] == 1 && B_reg[1] == 0) begin
                    P_reg = P_reg + (A_reg << 1);
                    state = 2;
                end else if (B_reg[0] == 0 && B_reg[1] == 1) begin
                    P_reg = P_reg + (A_reg >> 1);
                    state = 2;
                end else begin
                    state = 1;
                end
                B_reg = {B_reg[2], B_reg[3], B_reg[3], B_reg[3]};
                counter = counter - 1;
            end
        end
        2: begin
            if (counter == 0) begin
                state = 3;
            end else begin
                if (B_reg[0] == 0 && B_reg[1] == 0) begin
                    state = 1;
                end else if (B_reg[0] == 1 && B_reg[1] == 0) begin
                    P_reg = P_reg + (A_reg << 2);
                    state = 1;
                end else if (B_reg[0] == 0 && B_reg[1] == 1) begin
                    P_reg = P_reg + (A_reg >> 2);
                    state = 1;
                end else begin
                    state = 2;
                end
                B_reg = {B_reg[2], B_reg[3], B_reg[3], B_reg[3]};
                counter = counter - 1;
            end
        end
        3: begin
            P = P_reg;
            state = 0;
        end
    endcase
end

endmodule
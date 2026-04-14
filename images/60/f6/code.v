module top_module(
    A,
    B,
    reset,
    enable,
    load_A,
    load_B,
    EQ,
    GT,
    LT
);input [3:0] A;
    input [3:0] B;
    input reset;
    input enable;
    input load_A;
    input load_B;
    output reg EQ; // Change to reg
    output reg GT; // Change to reg
    output reg LT; // Change to reg

    reg [3:0] A_reg;
    reg [3:0] B_reg;

    always @(*) begin
        if (reset) begin
            A_reg <= 4'b0;
            B_reg <= 4'b0;
            EQ <= 1'b0;
            GT <= 1'b0;
            LT <= 1'b0;
        end else if (enable) begin
            if (load_A) begin
                A_reg <= A;
            end
            if (load_B) begin
                B_reg <= B;
            end
            if (A_reg == B_reg) begin
                EQ <= 1'b1;
                GT <= 1'b0;
                LT <= 1'b0;
            end else if (A_reg > B_reg) begin
                EQ <= 1'b0;
                GT <= 1'b1;
                LT <= 1'b0;
            end else begin
                EQ <= 1'b0;
                GT <= 1'b0;
                LT <= 1'b1;
            end
        end else begin
            EQ <= 1'b0;
            GT <= 1'b0;
            LT <= 1'b0;
        end
    end

endmodule
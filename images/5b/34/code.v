module top_module(
    input clk,               // Added clock signal input
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] M,
    output reg V
);reg [3:0] A_reg;
    reg [3:0] B_reg;
    reg [7:0] M_reg;
    reg [3:0] partial_product;
    reg [4:0] stage;

    always @(posedge clk) begin
        if (stage == 0) begin
            A_reg <= A;
            B_reg <= B;
            partial_product <= A_reg * B_reg[0];
            M_reg <= {4'b0, partial_product}; // Initialize M_reg
            stage <= 1;
        end
        else if (stage == 1) begin
            partial_product <= A_reg * B_reg[1];
            M_reg <= {M_reg[7:4], partial_product[3:0]}; // Corrected indexing for the upper bits
            stage <= 2;
        end
        else if (stage == 2) begin
            partial_product <= A_reg * B_reg[2];
            M_reg <= {M_reg[7:4], partial_product[3:0]}; // Corrected indexing for the upper bits
            stage <= 3;
        end
        else if (stage == 3) begin
            partial_product <= A_reg * B_reg[3];
            M_reg <= {M_reg[7:4], partial_product[3:0]}; // Corrected indexing for the upper bits
            stage <= 4;
        end
        else if (stage == 4) begin
            M <= M_reg;
            V <= (M_reg[7:4] != 0) ? 1 : 0; // Simplified the overflow checking
            stage <= 0;
        end
    end

endmodule
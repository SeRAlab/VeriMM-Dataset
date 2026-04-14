module CholeskyDecomposition (
    input clk,
    input rst,
    input [15:0] a11,
    input [15:0] a12,
    input [15:0] a21,
    input [15:0] a22,
    output reg [15:0] l11,
    output reg [15:0] l12,
    output reg [15:0] l21,
    output reg [15:0] l22,
    output reg done
);
    reg [15:0] temp1, temp2;
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            l11 <= 0;
            l12 <= 0;
            l21 <= 0;
            l22 <= 0;
            done <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    l11 <= a11; // l11 = a11
                    state <= 1;
                end
                1: begin
                    l21 <= a21 / l11; // l21 = a21 / l11
                    l12 <= a12; // l12 = a12
                    state <= 2;
                end
                2: begin
                    temp1 <= l12 * l21; // temp1 = l12 * l21
                    l22 <= a22 - temp1 * l21; // l22 = a22 - temp1 * l21
                    done <= 1;
                    state <= 3;
                end
                3: begin
                    done <= 0; // Reset done for next input
                    state <= 0; // Go back to initial state
                end
            endcase
        end
    end
endmodule
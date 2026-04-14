module cholesky_decomposition (
    input clk,
    input rst,
    input start,
    input [15:0] a11,
    input [15:0] a12,
    input [15:0] a21,
    input [15:0] a22,
    output reg [15:0] l11,
    output reg [15:0] l21,
    output reg [15:0] l22,
    output reg done
);
    reg [15:0] l1, l2, l3;
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            l11 <= 0;
            l21 <= 0;
            l22 <= 0;
            done <= 0;
            state <= 0;
        end
        else if (start) begin
            state <= 1;
            done <= 0;
        end
        else begin
            case (state)
                1: begin
                    l11 <= a11; // l11 = a11
                    l21 <= a21 / l11; // l21 = a21 / l11
                    state <= 2;
                end
                2: begin
                    l22 <= a22 - (l21 * l21); // l22 = a22 - (l21 * l21)
                    done <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
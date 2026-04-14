module CholeskyDecomp (
    input clk,
    input reset,
    input [3:0] a, // first row of matrix
    input [3:0] b, // second row of matrix
    output reg [3:0] l11,
    output reg [3:0] l21,
    output reg [3:0] l22
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        l11 <= 0;
        l21 <= 0;
        l22 <= 0;
    end else begin
        // Cholesky decomposition calculations
        l11 <= a; // l11 is the first diagonal element
        l21 <= b / l11; // l21 is the second row first column element
        l22 <= b - (l21 * l21); // l22 is calculated from the second row second column
    end
end

endmodule
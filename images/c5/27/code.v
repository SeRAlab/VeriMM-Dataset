module Multiplier(
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] C
);

    wire [3:0] B0, B1, B2, B3;
    wire [7:0] P0, P1, P2, P3;

    // Splitting B into 4 bits
    assign {B3, B2, B1, B0} = B;

    // Multiplying A with each bit of B
    assign P0 = A * B0;
    assign P1 = A * B1;
    assign P2 = A * B2;
    assign P3 = A * B3;

    // Combining the results to get the final output
    always @(*) begin
        C = {P3[7:4], P2[7:4], P1[7:4], P0[7:4]};
    end

endmodule
module top_module(
    input [2:0] A1,
    input [2:0] A2,
    input [2:0] B1,
    input [2:0] B2,
    input [2:0] C1,
    input [2:0] C2,
    input [2:0] D1,
    input [2:0] D2,
    output reg [2:0] Y
);always @* begin
        // Find the maximum of the A group
        if (A1 > A2) begin
            Y = A1;
        end else begin
            Y = A2;
        end

        // Find the maximum of the B group
        if (B1 > B2 && B1 > Y) begin
            Y = B1;
        end else if (B2 > Y) begin
            Y = B2;
        end

        // Find the maximum of the C group
        if (C1 > C2 && C1 > Y) begin
            Y = C1;
        end else if (C2 > Y) begin
            Y = C2;
        end

        // Find the maximum of the D group
        if (D1 > D2 && D1 > Y) begin
            Y = D1;
        end else if (D2 > Y) begin
            Y = D2;
        end
    end

endmodule
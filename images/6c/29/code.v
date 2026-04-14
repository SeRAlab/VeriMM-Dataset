module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] S,  // Change to reg
    output C
);wire [3:0] sum;
    wire carry;

    assign sum = A + B;
    assign C = (A[3] & B[3]) | ((A[3] | B[3]) & ~sum[3]);

    always @* begin
        if (C) begin
            S = sum + 1;
        end else begin
            S = sum;
        end
    end

endmodule
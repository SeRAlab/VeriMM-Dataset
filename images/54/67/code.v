module top_module(
    input [15:0] A,
    output reg [15:0] B
);always @(*) begin
        if (A[15] == 1) begin
            B = ~A + 1;
        end else begin
            B = A;
        end
    end

endmodule
module top_module(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output reg [3:0] SUM,
    output reg CARRY
);always @(*) begin
        if (SUB) begin
            SUM <= A - B;
            CARRY <= (A < B);
        end else begin
            SUM <= A + B;
            CARRY <= (SUM < A);
        end
    end

endmodule
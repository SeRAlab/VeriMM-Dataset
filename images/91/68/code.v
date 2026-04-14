module top_module(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output reg [3:0] SUM,
    output reg CARRY
);always @(*) begin
        if(SUB == 1) begin
            SUM = A - B;
            CARRY = (A < B) ? 1 : 0;
        end
        else begin
            SUM = A + B;
            CARRY = (SUM[4] == 1) ? 1 : 0;
        end
    end

endmodule
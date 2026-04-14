module top_module(
    input A,
    input B,
    input SEL,
    output reg Y
);always @ (SEL or A or B) begin
        case (SEL)
            1'b0: Y = A;
            1'b1: Y = B;
        endcase
    end

endmodule
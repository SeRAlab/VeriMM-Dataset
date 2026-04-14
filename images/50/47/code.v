module top_module(
    input A,
    input B,
    input SEL,
    output reg Y // Declare Y as reg
);always @(*) begin
        if (SEL == 0) begin
            Y = A;
        end else begin
            Y = B;
        end
    end

endmodule
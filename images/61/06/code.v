module top_module(
    input A,
    input B,
    input SEL,
    input RST,
    output reg Y
);always @(*) begin
    if (RST) begin
        Y <= 0;
    end else begin
        if (SEL) begin
            Y <= B;
        end else begin
            Y <= A;
        end
    end
end

endmodule
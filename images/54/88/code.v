module top_module(
    input A,
    input B,
    input C,
    input D,
    output reg Y
);always @(*) begin
        Y = ~(A | B | C | D);
    end

endmodule
module top_module(
    input A,
    input B,
    input CI,
    output reg SUM,
    output reg COUT
);always @(*) begin
        {COUT, SUM} = A + B + CI; // Full adder functionality
    end

endmodule
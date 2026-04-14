module top_module(
    input [2:0] a,
    input [2:0] b,
    input sel_b1,
    input sel_b2,
    output reg out_always,
    output reg [2:0] out_or_bitwise, // Changed to reg to match the usage in always block
    output out_or_logical,
    output [5:0] out_not
);// 2-to-1 multiplexer
    always @(*) begin
        if (sel_b1) begin
            out_or_bitwise <= b;
        end else if (sel_b2) begin
            out_or_bitwise <= a;
        end else begin
            out_or_bitwise <= b;
        end
    end

    // Bitwise-OR
    // Removed this assignment since it's redundant
    // assign out_or_bitwise = a | b;

    // Logical-OR
    assign out_or_logical = (a != 0) || (b != 0);

    // Inverse of both vectors
    assign out_not = ~{a, b};

endmodule
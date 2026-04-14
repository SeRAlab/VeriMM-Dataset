module top_module(
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    input clk,     // Added clk input
    output reg [7:0] out
);always @(*) begin
    case(op)
        2'b00: out = a + b;
        2'b01: out = a - b;
        2'b10: out = a & b;
        2'b11: out = a | b;
        default: out = 8'b0; // Added default case to handle undefined op
    endcase
end

always @(posedge clk) begin
    // The out variable is updated on the positive edge of the clock
    // It should be assigned the value from the combinatorial logic above.
    out <= out; // Note: This can be changed if you want to latch based on combinational logic.
end

endmodule
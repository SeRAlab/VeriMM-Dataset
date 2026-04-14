module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] out
);// Bitwise OR block
reg [3:0] or_result;
always @* begin
    or_result = a | b;
end

// 2's complement block
reg [3:0] twos_comp_result;
always @* begin
    twos_comp_result = ~or_result + 1;
end

// Difference block
reg [3:0] diff;
always @* begin
    diff = a - b;
end

// Output assignment
always @* begin
    out = twos_comp_result;
end

endmodule
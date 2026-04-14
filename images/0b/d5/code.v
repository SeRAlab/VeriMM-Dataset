module eight_bit_comparator(
    input [7:0] a,
    input [7:0] b,
    output reg [2:0] result
);

always @* begin
    if (a < b) begin
        result = 3'b001; // a is less than b
    end else if (a > b) begin
        result = 3'b010; // a is greater than b
    end else begin
        result = 3'b000; // a is equal to b
    end
end

endmodule
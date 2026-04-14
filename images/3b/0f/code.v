module comparator_64bit (
    input [63:0] a,
    input [63:0] b,
    output reg [1:0] result
);

always @(*) begin
    if (a < b) begin
        result = 2'b00; // a is less than b
    end else if (a == b) begin
        result = 2'b01; // a is equal to b
    end else begin
        result = 2'b10; // a is greater than b
    end
end

endmodule
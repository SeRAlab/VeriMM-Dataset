module comparator_32bit (
    input [31:0] a,
    input [31:0] b,
    output reg [1:0] result
);
    always @(*) begin
        if (a > b)
            result = 2'b10; // a is greater than b
        else if (a < b)
            result = 2'b01; // a is less than b
        else
            result = 2'b00; // a is equal to b
    end
endmodule
module comparator_64bit (
    input [63:0] A,
    input [63:0] B,
    output reg [1:0] result
);
    always @(*) begin
        if (A > B)
            result = 2'b10; // A is greater than B
        else if (A < B)
            result = 2'b01; // A is less than B
        else
            result = 2'b00; // A is equal to B
    end
endmodule
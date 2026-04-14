module magnitude_comparator(
    input [3:0] A,
    input [3:0] B,
    output reg [1:0] result // 00: A < B, 01: A = B, 10: A > B
);
    always @(*) begin
        if (A > B)
            result = 2'b10; // A > B
        else if (A < B)
            result = 2'b00; // A < B
        else
            result = 2'b01; // A = B
    end
endmodule
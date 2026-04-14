module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    always @(*) begin
        // Calculate the sum of A, B, and Cin
        Sum = A + B + Cin;

        // Set the carry-out bit if the sum is greater than 15
        if (Sum > 15) begin
            Cout = 1;
        end else begin
            Cout = 0;
        end
    end

endmodule
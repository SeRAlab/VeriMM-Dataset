module array_multiplier (
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
);
    reg [3:0] partial [3:0]; // Partial products
    integer i;

    always @(*) begin
        // Initialize partial products
        for (i = 0; i < 4; i = i + 1) begin
            partial[i] = (B[i] ? A : 4'b0000) << i; // Shift A left by i if B[i] is 1
        end
        
        // Sum the partial products
        P = partial[0] + partial[1] + partial[2] + partial[3];
    end
endmodule
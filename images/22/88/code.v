module BitwiseAnd(
    input [7:0] A,
    input [7:0] B,
    input enable,
    output reg [7:0] C
);
    always @(*) begin
        if (enable) 
            C = A & B; // Perform bitwise AND
        else 
            C = 8'b0; // Set output to zero
    end
endmodule
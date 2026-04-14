module matrix_inverse (
    input [3:0] matrix, // {A, B, C, D}
    output reg [7:0] inverse, // {inverse_A, inverse_B, inverse_C, inverse_D, valid}
    output reg valid
);
    wire [3:0] A = matrix[3:2];
    wire [3:0] B = matrix[1:0];
    wire [3:0] C = matrix[3:2];
    wire [3:0] D = matrix[1:0];
    
    wire [7:0] det = (A * D) - (B * C);
    
    always @(*) begin
        if (det == 0) begin
            inverse = 8'b0; // No inverse exists
            valid = 0;
        end else begin
            inverse[7:4] = (D / det); // inverse_A
            inverse[3:0] = (-B / det); // inverse_B
            inverse[7:4] = (-C / det); // inverse_C
            inverse[3:0] = (A / det); // inverse_D
            valid = 1;
        end
    end
endmodule
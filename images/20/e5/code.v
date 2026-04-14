module matrix_inverse (
    input [7:0] a, // Input matrix element a
    input [7:0] b, // Input matrix element b
    input [7:0] c, // Input matrix element c
    input [7:0] d, // Input matrix element d
    output reg [15:0] inv_a, // Output matrix element inv_a
    output reg [15:0] inv_b, // Output matrix element inv_b
    output reg [15:0] inv_c, // Output matrix element inv_c
    output reg [15:0] inv_d, // Output matrix element inv_d
    output reg valid // Output valid signal
);

    wire [15:0] det; // Determinant
    assign det = a * d - b * c;

    always @(*) begin
        if (det == 0) begin
            inv_a = 16'hFFFF; // Indicate invalid (NaN)
            inv_b = 16'hFFFF; // Indicate invalid (NaN)
            inv_c = 16'hFFFF; // Indicate invalid (NaN)
            inv_d = 16'hFFFF; // Indicate invalid (NaN)
            valid = 0;
        end else begin
            inv_a = d * 16'd10000 / det; // Scale up to avoid precision loss
            inv_b = -b * 16'd10000 / det; // Scale up to avoid precision loss
            inv_c = -c * 16'd10000 / det; // Scale up to avoid precision loss
            inv_d = a * 16'd10000 / det; // Scale up to avoid precision loss
            valid = 1;
        end
    end
endmodule
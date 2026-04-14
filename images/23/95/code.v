module matrix_inversion (
    input clk,
    input rst,
    input [15:0] a, // Element [0][0]
    input [15:0] b, // Element [0][1]
    input [15:0] c, // Element [1][0]
    input [15:0] d, // Element [1][1]
    output reg [15:0] inv_a, // Element [0][0] of Inverse
    output reg [15:0] inv_b, // Element [0][1] of Inverse
    output reg [15:0] inv_c, // Element [1][0] of Inverse
    output reg [15:0] inv_d, // Element [1][1] of Inverse
    output reg valid // Indicate valid output
);
    reg [31:0] det; // Determinant
    reg [31:0] temp; // Temporary variable for calculations

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            inv_a <= 16'b0;
            inv_b <= 16'b0;
            inv_c <= 16'b0;
            inv_d <= 16'b0;
            valid <= 1'b0;
        end else begin
            // Calculate determinant
            det <= a * d - b * c;
            if (det != 0) begin
                // Calculate the inverse matrix
                inv_a <= d / det; 
                inv_b <= -b / det;
                inv_c <= -c / det;
                inv_d <= a / det;
                valid <= 1'b1; // Output is valid
            end else begin
                // If determinant is zero, output zero matrix
                inv_a <= 16'b0;
                inv_b <= 16'b0;
                inv_c <= 16'b0;
                inv_d <= 16'b0;
                valid <= 1'b0; // Output is invalid
            end
        end
    end
endmodule
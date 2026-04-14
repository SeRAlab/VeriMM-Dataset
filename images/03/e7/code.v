module matrix_inverse(
    input [7:0] a, b, c, d,
    output reg [7:0] e, f, g, h
);
    wire signed [15:0] det;
    assign det = a * d - b * c;

    always @(*) begin
        if (det == 0) begin
            e = 8'b0; f = 8'b0; g = 8'b0; h = 8'b0; // No inverse
        end else begin
            e = d / det; 
            f = -b / det; 
            g = -c / det; 
            h = a / det; 
        end
    end
endmodule
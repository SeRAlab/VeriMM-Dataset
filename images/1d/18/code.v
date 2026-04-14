module bilinear_interpolation(
    input [7:0] I00, 
    input [7:0] I01, 
    input [7:0] I10, 
    input [7:0] I11,
    input [7:0] x, 
    input [7:0] y,
    output reg [7:0] Ixy
);
    wire [15:0] I00_term, I01_term, I10_term, I11_term;
    wire [15:0] x_inv, y_inv;

    assign x_inv = 16'h0100 - {8'b0, x}; // 1 - x
    assign y_inv = 16'h0100 - {8'b0, y}; // 1 - y

    assign I00_term = (I00 * x_inv * y_inv) >> 8;
    assign I01_term = (I01 * x_inv * {8'b0, y}) >> 8;
    assign I10_term = (I10 * {8'b0, x} * y_inv) >> 8;
    assign I11_term = (I11 * {8'b0, x} * {8'b0, y}) >> 8;

    always @(*) begin
        Ixy = (I00_term + I01_term + I10_term + I11_term) >> 8; // Combine and scale
    end
endmodule
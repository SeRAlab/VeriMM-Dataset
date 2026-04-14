module matrix_inversion (
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    input wire signed [31:0] c,
    input wire signed [31:0] d,
    output reg signed [31:0] a_inv,
    output reg signed [31:0] b_inv,
    output reg signed [31:0] c_inv,
    output reg signed [31:0] d_inv
);
    wire signed [31:0] det;
    
    assign det = a * d - b * c;

    always @(*) begin
        if (det == 0) begin
            a_inv = 32'bx;  // Indicating no inversion possible
            b_inv = 32'bx;
            c_inv = 32'bx;
            d_inv = 32'bx;
        end else begin
            a_inv = d / det;
            b_inv = -b / det;
            c_inv = -c / det;
            d_inv = a / det;
        end
    end
endmodule
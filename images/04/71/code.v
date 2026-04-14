module matrix_inverter (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [15:0] a_inv,
    output reg [15:0] b_inv,
    output reg [15:0] c_inv,
    output reg [15:0] d_inv
);

    wire signed [15:0] det = a * d - b * c;

    always @(*) begin
        if (det == 0) begin
            a_inv = 16'b0;
            b_inv = 16'b0;
            c_inv = 16'b0;
            d_inv = 16'b0;
        end else begin
            a_inv = d / det;
            b_inv = -b / det;
            c_inv = -c / det;
            d_inv = a / det;
        end
    end
endmodule
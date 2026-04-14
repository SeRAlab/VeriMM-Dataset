module matrix_inverse (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [7:0] c,
    input wire [7:0] d,
    output reg [15:0] inv_a,
    output reg [15:0] inv_b,
    output reg [15:0] inv_c,
    output reg [15:0] inv_d
);
    wire signed [15:0] det;
    assign det = (a * d) - (b * c);

    always @(*) begin
        if (det == 0) begin
            inv_a = 0;
            inv_b = 0;
            inv_c = 0;
            inv_d = 0;
        end else begin
            inv_a = d / det;
            inv_b = -b / det;
            inv_c = -c / det;
            inv_d = a / det;
        end
    end
endmodule
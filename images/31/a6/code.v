module matrix_inversion (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] a_inv,
    output reg [7:0] b_inv,
    output reg [7:0] c_inv,
    output reg [7:0] d_inv
);
    wire signed [15:0] det;
    assign det = (a * d) - (b * c);

    always @(*) begin
        if (det == 16'd0) begin
            a_inv = 8'd0;
            b_inv = 8'd0;
            c_inv = 8'd0;
            d_inv = 8'd0;
        end else begin
            a_inv = (d * 256) / det;      // scaling to keep the values in 8-bit range
            b_inv = (-b * 256) / det;     // scaling to keep the values in 8-bit range
            c_inv = (-c * 256) / det;     // scaling to keep the values in 8-bit range
            d_inv = (a * 256) / det;      // scaling to keep the values in 8-bit range
        end
    end
endmodule
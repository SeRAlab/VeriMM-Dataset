module qr_decomposition(
    input [7:0] a, b,
    input [7:0] c, d,
    output reg [7:0] q1, q2,
    output reg [7:0] r11, r12, r21, r22
);
    wire [15:0] norm;
    wire [15:0] r11_temp, r12_temp, r21_temp, r22_temp;

    assign norm = a * a + c * c;
    assign r11_temp = a;
    assign r12_temp = b;

    always @(*) begin
        q1 = a / (norm ** 0.5); // Q1
        q2 = c / (norm ** 0.5); // Q2
        
        r11 = r11_temp;
        r12 = r12_temp;
        r21 = c * (a / (norm ** 0.5));
        r22 = d * (c / (norm ** 0.5));
    end
endmodule
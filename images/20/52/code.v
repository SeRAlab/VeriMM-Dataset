module bilinear_interpolation (
    input [7:0] I00,     // intensity of pixel (0,0)
    input [7:0] I01,     // intensity of pixel (0,1)
    input [7:0] I10,     // intensity of pixel (1,0)
    input [7:0] I11,     // intensity of pixel (1,1)
    input [3:0] x_frac,  // fractional x coordinate (0 to 15)
    input [3:0] y_frac,  // fractional y coordinate (0 to 15)
    output reg [7:0] I_out // interpolated intensity
);

    wire [15:0] I0, I1, I2, I3;
    wire [15:0] x_weight, y_weight;

    assign x_weight = {8'b0, x_frac}; // scale x_frac to 16 bits
    assign y_weight = {8'b0, y_frac}; // scale y_frac to 16 bits

    assign I0 = I00 * (16'hFFFF - x_weight); // weight for I00
    assign I1 = I01 * (16'hFFFF - x_weight); // weight for I01
    assign I2 = I10 * x_weight;               // weight for I10
    assign I3 = I11 * x_weight;               // weight for I11

    always @(*) begin
        I_out = (I0 * (16'hFFFF - y_weight) + I1 * (16'hFFFF - y_weight) +
                 I2 * y_weight + I3 * y_weight) >> 16; // sum and scale back
    end
endmodule
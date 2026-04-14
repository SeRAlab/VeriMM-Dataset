module top_module(
    input I0,
    input I1,
    input I2,
    input I3,
    input S0,
    input S1,
    output reg O  // Changed to 'reg' to allow assignments in always block
);reg [15:0] lut;

    always @* begin
        case ({S1, S0})
            2'b00: O = lut[0];
            2'b01: O = lut[1];
            2'b10: O = lut[2];
            2'b11: O = lut[3];
        endcase
    end

    always @* begin
        lut[0] = I0;
        lut[1] = I1;
        lut[2] = I2;
        lut[3] = I3;
        lut[4] = I0;
        lut[5] = I1;
        lut[6] = I2;
        lut[7] = I3;
        lut[8] = I0;
        lut[9] = I1;
        lut[10] = I2;
        lut[11] = I3;
        lut[12] = I0;
        lut[13] = I1;
        lut[14] = I2;
        lut[15] = I3;
    end

endmodule
module cordic_sine_cosine (
    input [15:0] angle,
    output reg [15:0] sine,
    output reg [15:0] cosine
);

    reg [15:0] x [0:15];
    reg [15:0] y [0:15];
    reg [15:0] arctan [0:15];

    integer i;

    initial begin
        // Initialize values for CORDIC
        x[0] = 16'h7FFF; // cos(0) = 1.0 in Q15
        y[0] = 16'h0000; // sin(0) = 0.0 in Q15

        arctan[0] = 16'h0000; // arctan(0) = 0
        arctan[1] = 16'h3D90; // arctan(1/2) in Q15
        arctan[2] = 16'h3A4E; // arctan(1/4) in Q15
        arctan[3] = 16'h388E; // etc.
        arctan[4] = 16'h3744;
        arctan[5] = 16'h36A0;
        arctan[6] = 16'h3682;
        arctan[7] = 16'h367C;
        arctan[8] = 16'h3674;
        arctan[9] = 16'h3670;
        arctan[10] = 16'h366C;
        arctan[11] = 16'h366A;
        arctan[12] = 16'h3666;
        arctan[13] = 16'h3664;
        arctan[14] = 16'h3662;
        arctan[15] = 16'h3660;

    end

    always @(*) begin
        // Rotate based on angle input
        sine = y[0];
        cosine = x[0];
        for (i = 0; i < 16; i = i + 1) begin
            if (angle[i] == 1) begin
                // Clockwise rotation
                x[i+1] = x[i] - (y[i] >> i);
                y[i+1] = y[i] + (x[i] >> i);
            end else begin
                // Counter-clockwise rotation
                x[i+1] = x[i] + (y[i] >> i);
                y[i+1] = y[i] - (x[i] >> i);
            end
        end
        sine = y[16];
        cosine = x[16];
    end

endmodule
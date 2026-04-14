module cordic_sine_cosine (
    input wire clk,
    input wire reset,
    input wire [15:0] angle, // Input angle in radians (scaled)
    output reg [15:0] sine,   // Sine output
    output reg [15:0] cosine  // Cosine output
);
    reg [15:0] x [0:3]; // x values
    reg [15:0] y [0:3]; // y values
    reg [15:0] z;       // Remaining angle
    integer i;

    initial begin
        x[0] = 16'h26DD; // K factor for CORDIC
        y[0] = 0;
        sine = 0;
        cosine = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x[0] <= 16'h26DD; // K factor
            y[0] <= 0;
            z <= angle;
            sine <= 0;
            cosine <= 0;
        end else begin
            for (i = 0; i < 4; i = i + 1) begin
                if (z < 0) begin
                    z <= z + (16'h1A36 >> i); // arctan(2^-i)
                    y[i+1] <= y[i] + (x[i] >> i);
                    x[i+1] <= x[i] - (y[i] >> i);
                end else begin
                    z <= z - (16'h1A36 >> i);
                    y[i+1] <= y[i] - (x[i] >> i);
                    x[i+1] <= x[i] + (y[i] >> i);
                end
            end
            sine <= y[4];
            cosine <= x[4];
        end
    end
endmodule
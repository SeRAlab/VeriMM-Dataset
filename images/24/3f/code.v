module cordic(
    input [15:0] angle,
    output reg [15:0] sine,
    output reg [15:0] cosine
);
    reg [15:0] x = 16'h26DD; // Initial value for cos(0) = 1.0
    reg [15:0] y = 16'h0000; // Initial value for sin(0) = 0.0
    reg [15:0] z;
    integer i;

    always @(*) begin
        z = angle;
        x = 16'h26DD; // cos(0)
        y = 16'h0000; // sin(0)

        for (i = 0; i < 16; i = i + 1) begin
            if (z < 0) begin
                // Rotate clockwise
                x = x + (y >> i);
                y = y - (x >> i);
                z = z + (16'h1D89 >> i); // arctan(2^-i)
            end else begin
                // Rotate counter-clockwise
                x = x - (y >> i);
                y = y + (x >> i);
                z = z - (16'h1D89 >> i); // arctan(2^-i)
            end
        end
        
        sine = y;
        cosine = x;
    end
endmodule
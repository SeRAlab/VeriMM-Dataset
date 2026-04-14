module cordic_sine_cosine (
    input [15:0] angle,
    output reg [15:0] sine,
    output reg [15:0] cosine
);
    reg [15:0] x, y, z;
    reg [15:0] K;
    integer i;

    initial begin
        K = 16'h26DD; // Scaling factor for CORDIC
        x = K;
        y = 0;
        z = angle;
        
        for (i = 0; i < 16; i = i + 1) begin
            if (z < 0) begin
                x = x + (y >>> i);
                y = y - (x >>> i);
                z = z + (16'h1 << (15 - i));
            end else begin
                x = x - (y >>> i);
                y = y + (x >>> i);
                z = z - (16'h1 << (15 - i));
            end
        end
        
        sine = y;
        cosine = x;
    end
endmodule
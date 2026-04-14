module cordic_sine_cosine(  
    input [15:0] angle,  
    output reg [15:0] sine,  
    output reg [15:0] cosine  
);  
    // Number of iterations  
    parameter N = 16;  
    reg signed [15:0] x;  
    reg signed [15:0] y;  
    reg signed [15:0] z;  
    reg signed [15:0] atan_table [0:N-1];  
    integer i;  

    // Initialize atan_table  
    initial begin  
        atan_table[0] = 16'h2000; // atan(1)  
        atan_table[1] = 16'h1536; // atan(0.5)  
        atan_table[2] = 16'h0C90; // atan(0.25)  
        atan_table[3] = 16'h0632; // atan(0.125)  
        atan_table[4] = 16'h0314; // atan(0.0625)  
        atan_table[5] = 16'h0189; // atan(0.03125)  
        atan_table[6] = 16'h00C5; // atan(0.015625)  
        atan_table[7] = 16'h0062; // atan(0.0078125)  
        atan_table[8] = 16'h0031; // atan(0.00390625)  
        atan_table[9] = 16'h0018; // atan(0.001953125)  
        atan_table[10] = 16'h000C; // atan(0.0009765625)  
        atan_table[11] = 16'h0006; // atan(0.00048828125)  
        atan_table[12] = 16'h0003; // atan(0.000244140625)  
        atan_table[13] = 16'h0001; // atan(0.0001220703125)  
        atan_table[14] = 16'h0001; // atan(0.00006103515625)  
        atan_table[15] = 16'h0000; // atan(0)  
    end  

    always @(*) begin  
        // Initial values  
        x = 16'h4000; // Initial x = 1.0  
        y = 16'h0000; // Initial y = 0.0  
        z = angle;  

        // CORDIC iterations  
        for (i = 0; i < N; i = i + 1) begin  
            if (z < 0) begin  
                // Rotate clockwise  
                x = x + (y >>> i);  
                y = y - (x >>> i);  
                z = z + atan_table[i];  
            end else begin  
                // Rotate counter-clockwise  
                x = x - (y >>> i);  
                y = y + (x >>> i);  
                z = z - atan_table[i];  
            end  
        end  

        sine = y;  
        cosine = x;  
    end  
endmodule
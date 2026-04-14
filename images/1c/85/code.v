module cordic_calculator(  
    input clk,  
    input reset,  
    input [15:0] angle,  
    output reg [15:0] sine,  
    output reg [15:0] cosine  
);  
    parameter N = 16;  
    reg [15:0] x, y;  
    reg [15:0] z;  
    reg [3:0] i;  
    reg [15:0] atan_table [0:N-1];  

    initial begin  
        // Initialize atan values for CORDIC  
        atan_table[0] = 16'h3C90; // atan(1) = 45 degrees  
        atan_table[1] = 16'h3B6E; // atan(0.5)  
        // ... more values for atan(1/2^i)  
        atan_table[2] = 16'h3A8C;  
        atan_table[3] = 16'h39F2;  
        atan_table[4] = 16'h39A4;  
        //... continue initializing up to atan_table[15]  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x <= 16'h0001; // Initial x value (cos(0))  
            y <= 16'h0000; // Initial y value (sin(0))  
            z <= angle;  
            i <= 0;  
            sine <= 16'h0000;  
            cosine <= 16'h0000;  
        end else if (i < N) begin  
            if (z < 0) begin  
                // Perform CORDIC rotation  
                x <= x + (y >>> i);  
                y <= y - (x >>> i);  
                z <= z + atan_table[i];  
            end else begin  
                x <= x - (y >>> i);  
                y <= y + (x >>> i);  
                z <= z - atan_table[i];  
            end  
            i <= i + 1;  
        end else begin  
            sine <= y;  
            cosine <= x;  
        end  
    end  
endmodule
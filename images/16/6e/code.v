module cordic #(parameter WIDTH = 16, ITERATIONS = 16) (  
    input clk,  
    input rst,  
    input [WIDTH-1:0] angle,  
    output reg [WIDTH-1:0] sine,  
    output reg [WIDTH-1:0] cosine  
);  

    reg [WIDTH-1:0] x, y, z;  
    reg [WIDTH-1:0] K[0:ITERATIONS-1]; // Precomputed gain factors  
    reg [WIDTH-1:0] atan_table[0:ITERATIONS-1]; // Precomputed arctans  
    integer i;  

    initial begin  
        // Initialize gain factors and arctan values  
        K[0] = 16'h26DD; // K0 = 0.607252935008881256  
        K[1] = 16'h24B8; // K1 = 0.5406408174555976  
        // ... Add more gain factors and atan values for other iterations  
        atan_table[0] = 16'h2000; // atan(2^-0)  
        atan_table[1] = 16'h1400; // atan(2^-1)  
        // ... Fill with appropriate values  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x <= K[0];  
            y <= 0;  
            z <= angle;  
            sine <= 0;  
            cosine <= 0;  
        end else begin  
            for (i = 0; i < ITERATIONS; i = i + 1) begin  
                if (z < 0) begin  
                    x <= x + (y >>> i);  
                    y <= y - (x >>> i);  
                    z <= z + atan_table[i];  
                end else begin  
                    x <= x - (y >>> i);  
                    y <= y + (x >>> i);  
                    z <= z - atan_table[i];  
                end  
            end  
            sine <= y * K[ITERATIONS-1];  
            cosine <= x * K[ITERATIONS-1];  
        end  
    end  
endmodule
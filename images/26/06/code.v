module cordic_sine_cosine (  
    input [15:0] angle,  
    output reg [15:0] sine,  
    output reg [15:0] cosine  
);  
    reg [15:0] x, y;  
    reg [15:0] z;  
    integer i;  
    initial begin  
        x = 16'h26DD; // Fixed point representation of cos(0)  
        y = 16'h0000; // Fixed point representation of sin(0)  
        z = angle;  
        for (i = 0; i < 16; i = i + 1) begin  
            if (z < 0) begin  
                x = x + (y >> i);  
                y = y - (x >> i);  
                z = z + (16'h2000 >> i);  
            end else begin  
                x = x - (y >> i);  
                y = y + (x >> i);  
                z = z - (16'h2000 >> i);  
            end  
        end  
        sine = y;  
        cosine = x;  
    end  
endmodule
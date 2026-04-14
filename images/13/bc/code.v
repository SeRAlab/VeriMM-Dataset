module cordic_processor(  
    input clk,  
    input rst,  
    input [15:0] angle,  
    input mode,  
    output reg [15:0] sine,  
    output reg [15:0] cosine  
);  
    parameter N = 16;  
    reg [15:0] x, y, z;  
    reg [N-1:0] angle_table [0:N-1];  
    integer i;  
  
    initial begin  
        angle_table[0] = 16'h26DD;  
        angle_table[1] = 16'h1DB7;  
        angle_table[2] = 16'h1A3D;  
        angle_table[3] = 16'h0F57;  
        angle_table[4] = 16'h0C90;  
        angle_table[5] = 16'h0A3D;  
        angle_table[6] = 16'h05F5;  
        angle_table[7] = 16'h02D9;  
        angle_table[8] = 16'h0149;  
        angle_table[9] = 16'h007D;  
        angle_table[10] = 16'h003E;  
        angle_table[11] = 16'h001F;  
        angle_table[12] = 16'h000F;  
        angle_table[13] = 16'h0007;  
        angle_table[14] = 16'h0003;  
        angle_table[15] = 16'h0001;  
    end  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x <= 16'h0001;  
            y <= 16'h0000;  
            z <= 16'h0000;  
            sine <= 16'h0000;  
            cosine <= 16'h0000;  
        end else begin  
            x <= 16'h0001;  
            y <= 16'h0000;  
            z <= angle;  
            for (i = 0; i < N; i = i + 1) begin  
                if (z < 0) begin  
                    z <= z + angle_table[i];  
                    x <= x + (y >> i);  
                    y <= y - (x >> i);  
                end else begin  
                    z <= z - angle_table[i];  
                    x <= x - (y >> i);  
                    y <= y + (x >> i);  
                end  
            end  
            if (mode) begin  
                sine <= y;  
                cosine <= x;  
            end else begin  
                sine <= x;  
                cosine <= y;  
            end  
        end  
    end  
endmodule
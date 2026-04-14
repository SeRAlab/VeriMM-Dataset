module crc_generator (  
    input clk,  
    input reset,  
    input data_in,  
    input valid,  
    output reg [15:0] crc_out  
);  
    reg [15:0] crc;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 16'hFFFF;  
        end else if (valid) begin  
            crc[15] <= crc[14] ^ crc[12] ^ data_in;  
            crc[14] <= crc[13];  
            crc[13] <= crc[12];  
            crc[12] <= crc[11];  
            crc[11] <= crc[10];  
            crc[10] <= crc[9];  
            crc[9] <= crc[8];  
            crc[8] <= crc[7];  
            crc[7] <= crc[6];  
            crc[6] <= crc[5];  
            crc[5] <= crc[4];  
            crc[4] <= crc[3];  
            crc[3] <= crc[2];  
            crc[2] <= crc[1];  
            crc[1] <= crc[0];  
            crc[0] <= data_in;  
        end  
    end  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc_out <= 16'h0000;  
        end else if (valid) begin  
            crc_out <= crc;  
        end  
    end  
endmodule
module crc_generator(  
    input clk,  
    input reset,  
    input [3:0] data,  
    output reg [3:0] crc  
);  
    reg [3:0] temp_crc;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 4'b0000;  
            temp_crc <= 4'b0000;  
        end else begin  
            temp_crc[3] <= data[3] ^ crc[3] ^ crc[2];  
            temp_crc[2] <= data[2] ^ crc[2] ^ crc[1];  
            temp_crc[1] <= data[1] ^ crc[1] ^ crc[0];  
            temp_crc[0] <= data[0] ^ crc[0];  
            crc <= temp_crc;  
        end  
    end  
endmodule
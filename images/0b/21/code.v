module crc8 (  
    input clk,  
    input reset,  
    input data_in,  
    output reg [7:0] crc_out  
);  
    reg [7:0] crc;  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            crc <= 8'b0;  
        else begin  
            crc[0] <= data_in ^ crc[7];  
            crc[1] <= crc[0];  
            crc[2] <= crc[1];  
            crc[3] <= crc[2];  
            crc[4] <= crc[3];  
            crc[5] <= crc[4];  
            crc[6] <= crc[5];  
            crc[7] <= crc[6] ^ (data_in ? 1'b1 : 1'b0);  
        end  
    end  
    always @(posedge clk) begin  
        crc_out <= crc;  
    end  
endmodule
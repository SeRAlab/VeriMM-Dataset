module crc_generator(  
    input [15:0] data_in,  
    output reg [15:0] crc_out  
);  
    reg [15:0] crc;  
    integer i;  

    always @(*) begin  
        crc = 16'hFFFF; // Initial value  
        for (i = 0; i < 16; i = i + 1) begin  
            crc = crc ^ data_in[i];  
            if (crc[15])  
                crc = (crc << 1) ^ 16'hA001;  
            else  
                crc = crc << 1;  
        end  
        crc_out = crc;  
    end  
endmodule
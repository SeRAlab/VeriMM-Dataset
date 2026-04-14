module crc32_generator(  
    input [31:0] data_in,  
    output reg [31:0] crc_out  
);  
    // CRC-32 polynomial  
    parameter POLYNOMIAL = 32'hEDB88320;  
    integer i, j;  
    reg [31:0] crc;  

    always @(*) begin  
        crc = 32'hFFFFFFFF;  
        for (i = 0; i < 32; i = i + 1) begin  
            crc = crc ^ data_in[i];  
            for (j = 0; j < 8; j = j + 1) begin  
                if (crc[0] == 1'b1)  
                    crc = (crc >> 1) ^ POLYNOMIAL;  
                else  
                    crc = crc >> 1;  
            end  
        end  
        crc_out = ~crc;  
    end  
endmodule
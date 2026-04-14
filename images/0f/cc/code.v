module crc32_generator (  
    input [31:0] data_in,  
    output reg [31:0] crc_out  
);  
    wire [31:0] polynomial = 32'h04C11DB7; // CRC-32 polynomial  
    reg [31:0] crc;  
    integer i, j;  
     
    always @(*) begin  
        crc = 32'hFFFFFFFF;  
        for (i = 0; i < 32; i = i + 1) begin  
            crc = crc ^ (data_in[i] ? polynomial : 0);  
            for (j = 0; j < 32; j = j + 1) begin  
                if (crc[31])  
                    crc = (crc << 1) ^ polynomial;  
                else  
                    crc = crc << 1;  
            end  
        end  
        crc_out = ~crc;  
    end  
endmodule
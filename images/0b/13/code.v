module crc32_generator (  
    input [31:0] data_in,  
    output reg [31:0] crc_out  
);  
    reg [31:0] crc;  
    integer i;  

    always @(*) begin  
        crc = 32'hFFFFFFFF;  
        for (i = 0; i < 32; i = i + 1) begin  
            crc = crc ^ data_in[i];  
            if (crc[0])  
                crc = (crc >> 1) ^ 32'hEDB88320;  
            else  
                crc = crc >> 1;  
        end  
        crc_out = ~crc;  
    end  
endmodule
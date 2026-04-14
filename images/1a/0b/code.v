module crc32_generator (  
    input [31:0] data,  
    output reg [31:0] crc  
);  
    integer i;  
    reg [31:0] crc_temp;  
    always @(*) begin  
        crc_temp = 32'hFFFFFFFF;  
        for (i = 0; i < 32; i = i + 1) begin  
            if ((crc_temp[31] ^ data[31 - i]) == 1) begin  
                crc_temp = (crc_temp << 1) ^ 32'h04C11DB7;  
            end else begin  
                crc_temp = crc_temp << 1;  
            end  
        end  
        crc = ~crc_temp;  
    end  
endmodule
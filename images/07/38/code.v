module crc16_generator(input [15:0] data, input [15:0] polynomial, output reg [15:0] crc);  
    integer i, j;  
    reg [15:0] tmp;  

    always @(*) begin  
        tmp = data;  
        crc = 16'h0;  
        for (i = 0; i < 16; i = i + 1) begin  
            if (tmp[15] ^ crc[15]) begin  
                crc = crc ^ polynomial;  
            end  
            crc = crc << 1;  
            tmp = tmp << 1;  
        end  
    end  
endmodule
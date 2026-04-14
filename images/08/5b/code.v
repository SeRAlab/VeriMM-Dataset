module crc32_generator (  
    input [31:0] data_in,  
    output reg [31:0] crc_out  
);  
    integer i;  
    reg [31:0] crc;  
    reg [31:0] polynomial;  

    initial begin  
        crc = 32'hFFFFFFFF;  
        polynomial = 32'h04C11DB7;  
    end  

    always @(*) begin  
        crc = crc ^ data_in;  
        for (i = 0; i < 32; i = i + 1) begin  
            if (crc[31])  
                crc = (crc << 1) ^ polynomial;  
            else  
                crc = crc << 1;  
        end  
        crc_out = crc;  
    end  
endmodule
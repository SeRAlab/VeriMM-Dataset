module crc_generator (  
    input [15:0] data,  
    output reg [15:0] crc  
);  
    reg [15:0] polynomial = 16'hA001;  
    integer i;  

    always @(*) begin  
        crc = data;  
        for (i = 0; i < 16; i = i + 1) begin  
            if (crc[15])  
                crc = (crc << 1) ^ polynomial;  
            else  
                crc = crc << 1;  
        end  
    end  
endmodule
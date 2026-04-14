module crc_generator (  
    input [15:0] data,  
    input [15:0] polynomial,  
    output reg [15:0] crc  
);  
    integer i;  
    reg [15:0] tmp;  
    always @(*) begin  
        tmp = data;  
        crc = 16'b0;  
        for (i = 0; i < 16; i = i + 1) begin  
            if (tmp[15]) begin  
                tmp = tmp ^ polynomial;  
            end  
            tmp = tmp << 1;  
        end  
        crc = tmp;  
    end  
endmodule
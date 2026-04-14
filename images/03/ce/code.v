module crc32_generator(  
    input [31:0] data_in,  
    output reg [31:0] crc_out  
);  
    reg [31:0] crc;  
    integer i;  

    always @* begin  
        crc = 32'hFFFFFFFF;  
        for (i = 0; i < 32; i = i + 1) begin  
            crc = crc ^ data_in[i] ? crc << 1 : crc << 1 ^ 32'h04C11DB7;  
        end  
        crc_out = crc ^ 32'hFFFFFFFF;  
    end  
endmodule
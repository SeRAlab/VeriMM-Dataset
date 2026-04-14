module crc_generator (  
    input [15:0] data_in,  
    output reg [15:0] crc_out  
);  
    // CRC polynomial: x^16 + x^12 + x^5 + 1  
    parameter POLY = 16'b10000000000000101;  
    integer i;  
    reg [15:0] crc;  
    always @(*) begin  
        crc = 16'b0;  
        // Perform the division  
        for (i = 0; i < 16; i = i + 1) begin  
            crc = {crc[14:0], data_in[i]};  
            if (crc[15]) begin  
                crc = crc ^ POLY;  
            end  
        end  
        crc_out = crc;  
    end  
endmodule
module crc_generator (  
    input clk,  
    input reset,  
    input load,  
    input [31:0] data_in,  
    output reg [31:0] crc_out  
);  
    reg [31:0] crc;  
    reg [31:0] polynomial = 32'h04C11DB7; // Example polynomial for CRC-32  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 32'hFFFFFFFF; // Initial CRC value  
        end else if (load) begin  
            crc <= crc ^ data_in;  
            for (i = 0; i < 32; i = i + 1) begin  
                if (crc[31])  
                    crc <= (crc << 1) ^ polynomial;  
                else  
                    crc <= crc << 1;  
            end  
            crc_out <= crc;  
        end  
    end  
endmodule
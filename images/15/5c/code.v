module crc_generator (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] data_in,  
    output reg [31:0] crc_out  
);  
    reg [31:0] crc;  
    reg [31:0] polynomial = 32'h04C11DB7; // Standard CRC-32 polynomial  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 32'hFFFFFFFF; // Initial value  
        end else begin  
            crc <= crc ^ data_in; // XOR input data with current CRC  
            for (i = 0; i < 32; i = i + 1) begin  
                if (crc[31]) begin  
                    crc = (crc << 1) ^ polynomial;  
                end else begin  
                    crc = crc << 1;  
                end  
            end  
        end  
    end  

    always @(posedge clk) begin  
        crc_out <= crc;  
    end  
endmodule
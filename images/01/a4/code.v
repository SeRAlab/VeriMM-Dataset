module crc_generator (  
    input [7:0] data_in,  
    output reg [7:0] crc_out  
);  
    parameter POLY = 8'h1D; // Polynomial for CRC-8  
    integer i;  
    reg [7:0] crc;  

    always @(*) begin  
        crc = 8'h00;  
        for (i = 0; i < 8; i = i + 1) begin  
            crc = crc ^ data_in[i] ? (crc << 1) ^ POLY : (crc << 1);  
        end  
        crc_out = crc;  
    end  
endmodule
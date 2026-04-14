module crc_generator (  
    input [7:0] data_in,  
    output reg [7:0] crc_out  
);  
    wire [7:0] polynomial = 8'b100000111; // x^8 + x^7 + x^4 + 1  
    reg [15:0] crc;  
    integer i;  

    always @(*) begin  
        crc = {data_in, 8'b00000000}; // Append 8 zero bits to data  
        
        // Perform CRC calculation  
        for (i = 0; i < 8; i = i + 1) begin  
            if (crc[15]) begin  
                crc = crc ^ {polynomial, 8'b00000000};  
            end  
            crc = crc << 1;  
        end  

        crc_out = crc[7:0]; // Output the lower 8 bits as CRC  
    end  
endmodule
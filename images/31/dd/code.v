module crc_generator (  
    input [7:0] data,  
    output reg [7:0] crc  
);  
    integer i;  
    reg [7:0] crc_poly = 8'b100000111; // Polynomial x^8 + x^2 + x + 1  
    reg [7:0] data_temp;  

    always @(*) begin  
        data_temp = data;  
        crc = 8'b0;  
        for (i = 0; i < 8; i = i + 1) begin  
            if (crc[7] ^ data_temp[7]) begin  
                crc = (crc << 1) ^ crc_poly;  
            end else begin  
                crc = crc << 1;  
            end  
            data_temp = data_temp << 1;  
        end  
    end  
endmodule
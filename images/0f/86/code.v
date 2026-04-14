module crc8_generator(  
    input wire [7:0] data_in,  
    input wire clk,  
    output reg [7:0] crc_out  
);  
    reg [7:0] crc;  
    integer i;  

    always @(posedge clk) begin  
        crc = 8'b00000000;  
        for (i = 0; i < 8; i = i + 1) begin  
            crc = crc ^ data_in[i];  
            if (crc[7])  
                crc = {crc[6:0], 1'b0} ^ 8'b11000000; // Polynomial: x^8 + x^7 + x^6 + x^4 + x^3 + x^2 + 1  
            else  
                crc = {crc[6:0], 1'b0};  
        end  
        crc_out <= crc;  
    end  
endmodule
module crc_generator(  
    input [7:0] data_in,  
    output [7:0] crc_out  
);  
    reg [7:0] crc;  
    integer i;  

    always @(*) begin  
        crc = 8'b0;  
        for (i = 0; i < 8; i = i + 1) begin  
            crc = crc ^ data_in[i];  
            if (crc[7])  
                crc = {crc[6:0], 1'b0} ^ 8'b11010101; // Example polynomial  
            else  
                crc = {crc[6:0], 1'b0};  
        end  
    end  

    assign crc_out = crc;  
endmodule
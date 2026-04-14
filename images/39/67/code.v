module crc_generator (  
    input [7:0] data_in,  
    output [7:0] crc_out  
);  
    reg [7:0] crc;  
    integer i;  

    always @(*) begin  
        crc = data_in;  
        for (i = 0; i < 8; i = i + 1) begin  
            if (crc[7] == 1) begin  
                crc = {crc[6:0], 1'b0} ^ 8'b11000011; // x^8 + x^7 + x^4 + 1  
            end else begin  
                crc = {crc[6:0], 1'b0};  
            end  
        end  
    end  

    assign crc_out = crc;  
endmodule
module crc16_generator (  
    input wire clk,  
    input wire rst,  
    input wire [15:0] data_in,  
    input wire [15:0] polynomial,  
    output reg [15:0] crc_out  
);  
    reg [15:0] crc;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc <= 16'h0;  
            crc_out <= 16'h0;  
        end else begin  
            crc <= data_in;  
            for (i = 0; i < 16; i = i + 1) begin  
                if (crc[15]) begin  
                    crc = {crc[14:0], 1'b0} ^ polynomial;  
                end else begin  
                    crc = {crc[14:0], 1'b0};  
                end  
            end  
            crc_out <= crc;  
        end  
    end  
endmodule
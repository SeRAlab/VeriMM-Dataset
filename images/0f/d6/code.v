module crc_generator (  
    input clk,  
    input rst,  
    input [31:0] data_in,  
    input [31:0] polynomial,  
    output reg [31:0] crc_out  
);  
    reg [31:0] crc;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc <= 32'b0;  
        end else begin  
            crc <= crc ^ data_in;  
            for (i = 0; i < 32; i = i + 1) begin  
                if (crc[31] == 1'b1) begin  
                    crc <= (crc << 1) ^ polynomial;  
                end else begin  
                    crc <= crc << 1;  
                end  
            end  
        end  
    end  

    always @(posedge clk) begin  
        crc_out <= crc;  
    end  
endmodule
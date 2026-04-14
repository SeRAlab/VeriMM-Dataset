module crc_generator (  
    input wire clk,  
    input wire rst,  
    input wire [15:0] data_in,  
    input wire [15:0] poly,  
    output reg [15:0] crc_out  
);  
    reg [15:0] crc;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc <= 16'h0000;  
        end else begin  
            crc = data_in;  
            for (i = 0; i < 16; i = i + 1) begin  
                if (crc[15] == 1'b1) begin  
                    crc <= (crc << 1) ^ poly;  
                end else begin  
                    crc <= crc << 1;  
                end  
            end  
            crc_out <= crc;  
        end  
    end  
endmodule
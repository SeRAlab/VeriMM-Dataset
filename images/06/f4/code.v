module crc_generator (  
    input clk,  
    input reset,  
    input [15:0] data_in,  
    input [15:0] polynomial,  
    output reg [15:0] crc_out  
);  
    reg [15:0] crc;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 16'b0;  
        end else begin  
            crc = data_in;  
            for (i = 0; i < 16; i = i + 1) begin  
                if (crc[15] == 1'b1) begin  
                    crc = (crc << 1) ^ polynomial;  
                end else begin  
                    crc = crc << 1;  
                end  
            end  
            crc_out <= crc;  
        end  
    end  
endmodule
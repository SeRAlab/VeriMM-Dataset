module crc4 (  
    input [3:0] data_in,  
    input clk,  
    input rst,  
    output reg [3:0] crc_out  
);  
    reg [3:0] crc;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc <= 4'b0000;  
        end else begin  
            crc <= data_in;  
            for (i = 0; i < 4; i = i + 1) begin  
                if (crc[3] == 1) begin  
                    crc <= {crc[2:0], 1'b0} ^ 4'b1101; // Polynomial x^4 + x + 1  
                end else begin  
                    crc <= {crc[2:0], 1'b0};  
                end  
            end  
            crc_out <= crc;  
        end  
    end  
endmodule
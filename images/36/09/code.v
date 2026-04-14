module crc_generator(  
    input clk,  
    input reset,  
    input start,  
    input [15:0] data_in,  
    output reg [15:0] crc_out  
);  
    reg [15:0] crc;  
    reg [4:0] bit_count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 16'hFFFF; // Initial value for CRC  
            crc_out <= 16'h0000;  
            bit_count <= 0;  
        end else if (start) begin  
            if (bit_count < 16) begin  
                crc[15] <= crc[15] ^ data_in[15 - bit_count];  
                if (crc[15]) begin  
                    crc <= {crc[14:0], 1'b0} ^ 16'hA001; // Polynomial x^16 + x^12 + x^5 + 1  
                end else begin  
                    crc <= {crc[14:0], 1'b0};  
                end  
                bit_count <= bit_count + 1;  
            end else begin  
                crc_out <= crc;  
            end  
        end  
    end  
endmodule
module crc_generator (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [15:0] data_in,  
    output reg [15:0] crc_out,  
    output reg done  
);  
    reg [15:0] crc;  
    reg [4:0] bit_count;  
    reg calculating;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 16'hFFFF;  
            bit_count <= 0;  
            done <= 0;  
            calculating <= 0;  
        end else if (start && !calculating) begin  
            calculating <= 1;  
            crc <= 16'hFFFF;  
            bit_count <= 0;  
            done <= 0;  
        end else if (calculating) begin  
            if (bit_count < 16) begin  
                crc[15:1] <= crc[14:0];  
                crc[0] <= crc[15] ^ data_in[15 - bit_count];  
                if (crc[0] == 1) begin  
                    crc[15:0] <= crc[15:0] ^ 16'hA001;  
                end  
                bit_count <= bit_count + 1;  
            end else begin  
                crc_out <= crc;  
                done <= 1;  
                calculating <= 0;  
            end  
        end  
    end  
endmodule
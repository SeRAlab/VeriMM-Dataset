module crc32_generator(  
    input wire clk,  
    input wire rst,  
    input wire [31:0] data_in,  
    input wire start,  
    output reg [31:0] crc_out,  
    output reg done  
);  
    reg [31:0] crc;  
    reg [5:0] bit_count;  
    reg calculating;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc <= 32'hFFFFFFFF;  
            bit_count <= 0;  
            calculating <= 0;  
            crc_out <= 0;  
            done <= 0;  
        end else if (start && !calculating) begin  
            crc <= 32'hFFFFFFFF;  
            bit_count <= 0;  
            calculating <= 1;  
            done <= 0;  
        end else if (calculating) begin  
            if (bit_count < 32) begin  
                crc <= (crc >> 1) ^ ((crc & 1) ? 32'hEDB88320 : 32'h00000000) ^ (data_in[31 - bit_count] ? 32'hFFFFFFFF : 32'h00000000);  
                bit_count <= bit_count + 1;  
            end else begin  
                crc_out <= ~crc;  
                calculating <= 0;  
                done <= 1;  
            end  
        end  
    end  
endmodule
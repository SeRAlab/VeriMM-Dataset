module crc_generator (  
    input clk,  
    input reset,  
    input start,  
    input [7:0] data_in,  
    output reg [7:0] crc_out,  
    output reg done  
);  

    reg [7:0] crc;  
    reg [3:0] bit_count;  
    reg processing;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 8'b0;  
            bit_count <= 4'b0;  
            done <= 0;  
            processing <= 0;  
        end else if (start) begin  
            crc <= 8'b0;  
            bit_count <= 4'b0;  
            done <= 0;  
            processing <= 1;  
        end else if (processing) begin  
            if (bit_count < 8) begin  
                crc <= {crc[6:0], 1'b0} ^ (crc[7] ? 8'h07 : 8'b0);  
                crc[0] <= crc[0] ^ data_in[7-bit_count];  
                bit_count <= bit_count + 1;  
            end else begin  
                crc_out <= crc;  
                done <= 1;  
                processing <= 0;  
            end  
        end  
    end  
endmodule
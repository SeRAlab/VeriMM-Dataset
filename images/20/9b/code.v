module crc32_generator (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] data_in,  
    input wire start,  
    output reg [31:0] crc_out,  
    output reg done  
);  
  
    reg [31:0] crc;  
    reg [31:0] polynomial;  
    reg [5:0] bit_index;  
    reg processing;  
  
    initial begin  
        crc = 32'hFFFFFFFF;  
        polynomial = 32'h04C11DB7;  
        bit_index = 0;  
        done = 0;  
        processing = 0;  
    end  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 32'hFFFFFFFF;  
            done <= 0;  
            processing <= 0;  
            bit_index <= 0;  
        end else if (start && !processing) begin  
            crc <= 32'hFFFFFFFF;  
            bit_index <= 0;  
            processing <= 1;  
        end else if (processing) begin  
            if (bit_index < 32) begin  
                crc <= (crc << 1) ^ ((crc[31] ^ data_in[bit_index]) ? polynomial : 32'h0);  
                bit_index <= bit_index + 1;  
            end else begin  
                crc_out <= crc;  
                done <= 1;  
                processing <= 0;  
            end  
        end  
    end  
endmodule
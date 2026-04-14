module crc32_generator (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] data_in,  
    input wire start,  
    output reg [31:0] crc_out,  
    output reg done  
);  

    parameter POLYNOMIAL = 32'hEDB88320;  
    reg [31:0] crc;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 32'hFFFFFFFF;  
            crc_out <= 32'h0;  
            done <= 1'b0;  
        end else if (start) begin  
            crc <= 32'hFFFFFFFF;  
            for (i = 0; i < 32; i = i + 1) begin  
                crc = (crc >> 1) ^ (POLYNOMIAL & {32{crc[0]}});  
                crc[31] = data_in[31 - i];  
            end  
            crc_out <= ~crc;  
            done <= 1'b1;  
        end  
    end  
endmodule
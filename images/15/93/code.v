module crc_4bit (  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    input valid,  
    output reg [3:0] crc_out  
);  
    reg [3:0] crc;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 4'b0;  
        end else if (valid) begin  
            crc <= (crc << 1) ^ ((crc[3] ^ data_in[3]) ? 4'b11001 : 4'b00000);  
        end  
    end  
    always @(*) begin  
        crc_out = crc;  
    end  
endmodule
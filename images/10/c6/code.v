module crc_generator (  
    input clk,  
    input [15:0] data_in,  
    output reg [15:0] crc_out  
);  
    reg [15:0] crc;  
    integer i;  
  
    always @(posedge clk) begin  
        crc = 16'hFFFF; // Initial value  
        for (i = 0; i < 16; i = i + 1) begin  
            crc[15] = crc[15] ^ data_in[i];  
            if (crc[15] == 1'b1) begin  
                crc = {crc[14:0], 1'b0} ^ 16'hA001; // Polynomial x^16 + x^12 + x^5 + 1  
            end else begin  
                crc = {crc[14:0], 1'b0};  
            end  
        end  
        crc_out <= crc;  
    end  
endmodule
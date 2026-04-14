module crc_4bit (  
    input wire [3:0] data_in,  
    input wire clk,  
    output reg [3:0] crc_out  
);  
    reg [3:0] crc;  
    integer i;  

    always @(posedge clk) begin  
        crc = 4'b0000; // Initialize CRC to 0  
        for (i = 0; i < 4; i = i + 1) begin  
            crc = {crc[2:0], data_in[i]} ^ (crc[3] ? 4'b1011 : 4'b0000);  
        end  
        crc_out <= crc;  
    end  
endmodule
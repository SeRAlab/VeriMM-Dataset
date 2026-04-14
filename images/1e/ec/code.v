module crc_generator (  
    input [3:0] data_in,  
    input clk,  
    input reset,  
    output reg [3:0] crc_out  
);  
    reg [3:0] crc;  
    wire [7:0] polynomial = 8'b11010000; // x^4 + x^3 + x^2 + 1  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 4'b0000;  
        end else begin  
            crc <= (crc << 1) ^ (data_in[3] ^ crc[3] ? polynomial[3:0] : 4'b0000);  
            crc <= (crc << 1) ^ (data_in[2] ^ crc[3] ? polynomial[3:0] : 4'b0000);  
            crc <= (crc << 1) ^ (data_in[1] ^ crc[3] ? polynomial[3:0] : 4'b0000);  
            crc <= (crc << 1) ^ (data_in[0] ^ crc[3] ? polynomial[3:0] : 4'b0000);  
        end  
    end  

    always @(posedge clk) begin  
        crc_out <= crc;  
    end  
endmodule
module crc_generator (  
    input wire [3:0] data_in,  
    input wire [3:0] polynomial,  
    output reg [3:0] crc_out,  
    input wire clk,  
    input wire rst  
);  
    reg [3:0] crc;  
    reg [3:0] data;  
    reg [3:0] poly;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc <= 4'b0000;  
        end else begin  
            data <= data_in;  
            poly <= polynomial;  
            crc <= data ^ crc;  
            crc_out <= crc ^ (crc & poly);  
        end  
    end  
endmodule
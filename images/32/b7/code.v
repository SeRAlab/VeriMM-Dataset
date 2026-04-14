module crc8_generator (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input valid,  
    output reg [7:0] crc_out  
);  
    reg [7:0] crc;  
    reg [3:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            crc <= 8'b0;  
            count <= 4'b0;  
            crc_out <= 8'b0;  
        end else begin  
            if (valid) begin  
                crc <= data_in;  
                count <= 4'b1;  
            end else if (count < 4'd8) begin  
                // Assume polynomial x^8 + x^2 + x + 1 (0xA7)  
                crc <= {crc[6:0], 1'b0} ^ (crc[7] ? 8'hA7 : 8'b0);  
                count <= count + 1;  
            end else if (count == 4'd8) begin  
                crc_out <= crc;  
                count <= count + 1;  
            end  
        end  
    end  
endmodule
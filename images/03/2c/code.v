module crc_calculator(input wire clk, input wire reset, input wire [3:0] data_in, output reg [2:0] crc_out);  
    reg [2:0] crc;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 3'b000;  
        end else begin  
            crc = crc;  
            for (i = 0; i < 4; i = i + 1) begin  
                crc[2] <= (crc[2] ^ data_in[i]);  
                crc[1] <= crc[1];  
                crc[0] <= (crc[0] ^ data_in[i]);  
                if (crc[2]) begin  
                    crc[2] <= 0;  
                    crc[1] <= (crc[1] ^ 1);  
                    crc[0] <= (crc[0] ^ 1);  
                end  
            end  
            crc_out <= crc;  
        end  
    end  
endmodule
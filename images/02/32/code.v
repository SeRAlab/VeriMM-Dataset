module crc8_calculator(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg [7:0] crc_out,  
    output reg ready  
);  
    reg [7:0] crc;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 8'h00;  
            ready <= 0;  
            crc_out <= 8'h00;  
        end else if (start) begin  
            crc <= 8'h00;  
            ready <= 0;  
            for (i = 0; i < 8; i = i + 1) begin  
                crc[7] <= crc[6] ^ data_in[i];  
                crc[6] <= crc[5];  
                crc[5] <= crc[4];  
                crc[4] <= crc[3];  
                crc[3] <= crc[2];  
                crc[2] <= crc[1];  
                crc[1] <= crc[0];  
                crc[0] <= crc[7];  
                if (crc[7]) begin  
                    crc[7:0] = crc[7:0] ^ 8'hA6; // x^8 + x^5 + x^4 + 1  
                end  
            end  
            crc_out <= crc;  
            ready <= 1;  
        end  
    end  
endmodule
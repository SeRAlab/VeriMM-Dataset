module crc_generator (  
    input clk,  
    input reset,  
    input [7:0] data,  
    input data_valid,  
    output reg [7:0] crc_out  
);  
    reg [7:0] crc;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            crc <= 8'b0;  
            crc_out <= 8'b0;  
        end else if (data_valid) begin  
            crc <= data;  
            for (i = 0; i < 8; i = i + 1) begin  
                // Shift left, simulate polynomial division  
                crc = {crc[6:0], 1'b0};  
                if (crc[7]) begin  
                    crc = crc ^ 8'b10000011; // x^8 + x^2 + x + 1  
                end  
            end  
            crc_out <= crc;  
        end  
    end  
endmodule
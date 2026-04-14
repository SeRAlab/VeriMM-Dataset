module crc_generator(  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    output reg [7:0] crc_out  
);  
    reg [7:0] crc;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            crc <= 8'b0;  
        else begin  
            crc <= data_in;  
            for (i = 0; i < 8; i = i + 1) begin  
                if (crc[7] == 1'b1)  
                    crc <= {crc[6:0], 1'b0} ^ 8'b11100011;  
                else  
                    crc <= {crc[6:0], 1'b0};  
            end  
            crc_out <= crc;  
        end  
    end  
endmodule
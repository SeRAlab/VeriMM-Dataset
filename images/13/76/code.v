module spi_controller(  
    input wire clk,  
    input wire cs,  
    input wire [7:0] data_in,  
    output reg mosi,  
    output reg done  
);  
    reg [2:0] bit_count;  

    always @(posedge clk or negedge cs) begin  
        if (!cs) begin  
            bit_count <= 3'b000;  
            done <= 0;  
        end else begin  
            if (bit_count < 3'd8) begin  
                mosi <= data_in[7 - bit_count];  
                bit_count <= bit_count + 1;  
            end else begin  
                done <= 1;  
            end  
        end  
    end  
endmodule
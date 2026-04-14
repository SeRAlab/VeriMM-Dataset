module dma_controller(  
    input wire clk,  
    input wire rst,  
    input wire rd_en_ch1,  
    input wire wr_en_ch1,  
    input wire [3:0] addr_ch1,  
    input wire rd_en_ch2,  
    input wire wr_en_ch2,  
    input wire [3:0] addr_ch2,  
    output reg active_ch1,  
    output reg active_ch2  
);  
    always @(posedge clk or negedge rst) begin  
        if (!rst) begin  
            active_ch1 <= 0;  
            active_ch2 <= 0;  
        end else begin  
            active_ch1 <= rd_en_ch1 && wr_en_ch1;  
            active_ch2 <= rd_en_ch2 && wr_en_ch2;  
        end  
    end  
endmodule
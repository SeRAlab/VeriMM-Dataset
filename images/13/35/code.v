module dma_controller (  
    input wire [3:0] request,  
    input wire [3:0] grant,  
    input wire clk,  
    output reg [1:0] active_channel,  
    output reg transfer  
);  
    always @(posedge clk) begin  
        if (request != 4'b0000) begin  
            active_channel <= grant;  
            transfer <= 1;  
        end else begin  
            transfer <= 0;  
        end  
    end  
endmodule
module dma_controller(  
    input clk,  
    input reset,  
    input [2:0] channel_num,  
    input request,  
    output reg acknowledge,  
    output reg busy  
);  
    reg [2:0] active_channel;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            active_channel <= 3'b000;  
            acknowledge <= 1'b0;  
            busy <= 1'b0;  
        end else begin  
            if (request && !busy) begin  
                active_channel <= channel_num;  
                busy <= 1'b1;  
                acknowledge <= 1'b1;  
            end else if (busy) begin  
                acknowledge <= 1'b0;  
                busy <= 1'b0;  
            end  
        end  
    end  
endmodule
module dma_controller (  
    input clk,  
    input reset,  
    input enable,  
    output reg [2:0] active_channel  
);  

    reg [2:0] channel;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            channel <= 3'b000;  
            active_channel <= 3'b000;  
        end else if (enable) begin  
            if (channel < 3'b111)  
                channel <= channel + 1;  
            else  
                channel <= 3'b000;  
            active_channel <= channel;  
        end  
    end  
endmodule
module dma_controller (  
    input wire clk,  
    input wire reset,  
    input wire [2:0] channel_select,  
    input wire enable,  
    output reg [7:0] channel_output  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            channel_output <= 8'b00000000;  
        else if (enable)  
            channel_output <= (1 << channel_select);  
        else  
            channel_output <= 8'b00000000;  
    end  
endmodule
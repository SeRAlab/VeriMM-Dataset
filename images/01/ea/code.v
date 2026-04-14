module dma_controller(  
    input clk,  
    input reset,  
    input [3:0] req,  
    output reg [3:0] grant  
);  
    reg [1:0] current_channel;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            grant <= 4'b0000;  
            current_channel <= 2'b00;  
        end else begin  
            grant <= 4'b0000;  
            if (req != 4'b0000) begin  
                grant[current_channel] <= 1'b1;  
                current_channel <= (current_channel + 1) % 4;  
            end  
        end  
    end  
endmodule
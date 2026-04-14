module dma_controller(  
    input clk,  
    input reset,  
    input [3:0] enable,  
    output reg [3:0] transfer_in_progress  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        transfer_in_progress <= 4'b0000;  
    end else begin  
        transfer_in_progress <= enable;  
    end  
end  
endmodule
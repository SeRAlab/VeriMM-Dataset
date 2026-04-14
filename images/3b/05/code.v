module dma_controller(  
    input wire [1:0] channel_select,  
    input wire enable,  
    output reg [3:0] busy  
);  
    always @(posedge enable) begin  
        busy <= 4'b0000; // Clear all channels  
        case (channel_select)  
            2'b00: busy[0] <= 1'b1;  
            2'b01: busy[1] <= 1'b1;  
            2'b10: busy[2] <= 1'b1;  
            2'b11: busy[3] <= 1'b1;  
            default: busy <= 4'b0000;  
        endcase  
    end  
    always @(negedge enable) begin  
        busy <= 4'b0000; // Clear all channels when enable is low  
    end  
endmodule
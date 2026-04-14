module dma_controller(  
    input clk,  
    input reset,  
    input [3:0] req,   // Request signals for 4 channels  
    output reg [1:0] grant,  // Grant signal to indicate the channel being served  
    output reg done   // Done signal indicating transfer completion  
);  
    reg [1:0] current_channel;  
    reg [1:0] next_channel;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_channel <= 2'b00;  
            grant <= 2'b00;  
            done <= 1'b0;  
        end else begin  
            if (req[current_channel]) begin  
                grant <= current_channel;  
                done <= 1'b1;  
            end else begin  
                done <= 1'b0;  
            end  

            // Cycle through channels  
            if (current_channel == 2'b11)  
                next_channel <= 2'b00;  
            else  
                next_channel <= current_channel + 1;  

            current_channel <= next_channel;  
        end  
    end  
endmodule
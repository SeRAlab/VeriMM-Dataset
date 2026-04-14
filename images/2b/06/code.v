module dma_controller(  
    input clk,  
    input reset,  
    input start,  
    input [1:0] channel_select,  
    output reg transfer_complete,  
    output reg [7:0] data_out  
);  

    reg [7:0] source[1:0];  
    reg [7:0] destination[1:0];  
    reg [1:0] current_channel;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            transfer_complete <= 0;  
            data_out <= 0;  
            current_channel <= 0;  
        end else if (start) begin  
            current_channel <= channel_select;  
            // Simulate data transfer  
            data_out <= source[current_channel];  
            destination[current_channel] <= data_out;  
            transfer_complete <= 1;  
        end else begin  
            transfer_complete <= 0;  
        end  
    end  
endmodule
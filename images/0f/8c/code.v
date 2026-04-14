module dma_controller(  
    input wire clk,  
    input wire rst,  
    input wire [2:0] channel_select,  
    input wire start_transfer,  
    output reg transfer_complete  
);  
    reg [2:0] current_channel;  
    reg transfer_active;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            transfer_complete <= 0;  
            transfer_active <= 0;  
            current_channel <= 3'b000;  
        end else begin  
            if (start_transfer && !transfer_active) begin  
                current_channel <= channel_select;  
                transfer_active <= 1;  
                transfer_complete <= 0;  
            end else if (transfer_active) begin  
                // Simulate data transfer complete after some clock cycles  
                transfer_complete <= 1;  
                transfer_active <= 0;  
            end  
        end  
    end  
endmodule
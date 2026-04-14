module dma_controller(  
    input wire clk,  
    input wire rst,  
    input wire channel_select, // 0 for Channel 0, 1 for Channel 1  
    input wire transfer_enable,  
    output reg transfer_complete,  
    output reg [1:0] active_channel, // 00 for Channel 0, 01 for Channel 1  
    output reg mem_read,  
    output reg mem_write  
);  

    reg [3:0] byte_count; // Number of bytes to transfer  
    reg [1:0] state; // State of DMA transfer (00: idle, 01: transfer, 10: complete)  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 2'b00;  
            byte_count <= 4'b0000;  
            transfer_complete <= 1'b0;  
            mem_read <= 1'b0;  
            mem_write <= 1'b0;  
            active_channel <= 2'b00;  
        end else begin  
            case (state)  
                2'b00: begin // Idle state  
                    if (transfer_enable) begin  
                        active_channel <= channel_select ? 2'b01 : 2'b00;  
                        byte_count <= 4'b0010; // Example: Transfer 2 bytes  
                        mem_read <= ~channel_select; // Read from memory for Channel 0  
                        mem_write <= channel_select; // Write to memory for Channel 1  
                        state <= 2'b01;  
                    end  
                end  
                2'b01: begin // Transfer state  
                    if (byte_count > 0) begin  
                        byte_count <= byte_count - 1;  
                    end else begin  
                        state <= 2'b10;  
                    end  
                end  
                2'b10: begin // Complete state  
                    transfer_complete <= 1'b1;  
                    mem_read <= 1'b0;  
                    mem_write <= 1'b0;  
                    state <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule
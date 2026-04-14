module dma_controller (  
    input clk,  
    input rst,  
    input [1:0] channel_select,  
    input start_transfer,  
    output reg transfer_complete,  
    output reg [7:0] source_address,  
    output reg [7:0] destination_address  
);  

    reg [7:0] data;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            transfer_complete <= 0;  
            source_address <= 8'h00;  
            destination_address <= 8'h00;  
        end else if (start_transfer) begin  
            case (channel_select)  
                2'b00: begin  
                    source_address <= 8'hA0;  
                    destination_address <= 8'hB0;  
                    data <= 8'hFF;  // Example data for Channel 0  
                end  
                2'b01: begin  
                    source_address <= 8'hC0;  
                    destination_address <= 8'hD0;  
                    data <= 8'hAA;  // Example data for Channel 1  
                end  
                default: begin  
                    source_address <= 8'h00;  
                    destination_address <= 8'h00;  
                end  
            endcase  
            transfer_complete <= 1;  
        end else begin  
            transfer_complete <= 0;  
        end  
    end  
endmodule
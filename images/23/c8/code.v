module dma_controller(  
    input wire clk,  
    input wire reset,  
    input wire start_transfer,  
    input wire [7:0] source_addr,  
    input wire [7:0] dest_addr,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out,  
    output reg transfer_complete  
);  
    reg [2:0] state;  
    parameter IDLE = 3'b000, TRANSFER = 3'b001, COMPLETE = 3'b010;  
     
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            data_out <= 16'b0;  
            transfer_complete <= 1'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_transfer) begin  
                        state <= TRANSFER;  
                        data_out <= data_in;  
                    end  
                end  
                TRANSFER: begin  
                    // Simulate data transfer  
                    state <= COMPLETE;  
                end  
                COMPLETE: begin  
                    transfer_complete <= 1'b1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
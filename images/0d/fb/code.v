module dma_controller(  
    input clk,  
    input reset,  
    input req,  
    input ready,  
    output reg [7:0] src_addr,  
    output reg [7:0] dest_addr,  
    output reg transfer_active  
);  

    reg [1:0] state;  
    parameter IDLE = 2'b00, TRANSFER = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            src_addr <= 8'b0;  
            dest_addr <= 8'b0;  
            transfer_active <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (req) begin  
                        src_addr <= 8'hAA; // Example source address  
                        dest_addr <= 8'h55; // Example destination address  
                        transfer_active <= 1;  
                        state <= TRANSFER;  
                    end  
                end  
                TRANSFER: begin  
                    if (ready) begin  
                        // Perform data transfer logic here  
                        // For simplicity, we just go to DONE state  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    transfer_active <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
module dma_controller(clk, reset, enable, src_addr, dest_addr, data_in, data_out, transfer_done);  
    input clk;  
    input reset;  
    input [3:0] enable;  
    input [7:0] src_addr;  
    input [7:0] dest_addr;  
    input [15:0] data_in;  
    output reg [15:0] data_out;  
    output reg transfer_done;  
      
    reg [1:0] state;  
    reg [3:0] channel;  
      
    parameter IDLE = 2'b00, TRANSFER = 2'b01, DONE = 2'b10;  
      
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            transfer_done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (enable != 4'b0000) begin  
                        channel <= enable;  
                        state <= TRANSFER;  
                    end  
                end  
                TRANSFER: begin  
                    data_out <= data_in;  // Simulating data transfer  
                    state <= DONE;  
                end  
                DONE: begin  
                    transfer_done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
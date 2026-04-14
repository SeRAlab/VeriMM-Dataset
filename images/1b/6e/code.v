module dma_controller(  
    input clk,  
    input reset,  
    input [3:0] req,  // Request signals for 4 channels  
    output reg [3:0] grant,  // Grant signals for 4 channels  
    output reg busy,  // Busy signal  
    input [7:0] data_in,  // Data input  
    output reg [7:0] data_out  // Data output  
);  
    reg [1:0] state;  
    reg [1:0] next_state;  
    parameter IDLE = 2'b00, TRANSFER = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            busy <= 0;  
            grant <= 4'b0000;  
            data_out <= 8'b00000000;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(*) begin  
        next_state = state;  
        grant = 4'b0000;  
        case (state)  
            IDLE: begin  
                if (req != 4'b0000) begin  
                    busy = 1;  
                    grant = req;  // Grant the requested channels  
                    next_state = TRANSFER;  
                end  
            end  
            TRANSFER: begin  
                data_out = data_in;  // Transfer data  
                next_state = DONE;  
            end  
            DONE: begin  
                busy = 0;  
                next_state = IDLE;  
            end  
        endcase  
    end  
endmodule
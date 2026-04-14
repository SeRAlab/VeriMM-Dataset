module nvme_controller(  
    input clk,  
    input reset,  
    input start,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00, COMMAND = 2'b01, DATA_TRANSFER = 2'b10;  
      
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= COMMAND;  
                COMMAND: state <= DATA_TRANSFER;  
                DATA_TRANSFER: state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule
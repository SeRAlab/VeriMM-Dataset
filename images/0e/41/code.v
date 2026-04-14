module SATA_Controller (  
    input clk,  
    input reset,  
    input start_transfer,  
    input error_detected,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00,  
              TRANSFER = 2'b01,  
              ERROR = 2'b10;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start_transfer)  
                        state <= TRANSFER;  
                end  
                TRANSFER: begin  
                    if (error_detected)  
                        state <= ERROR;  
                    else  
                        state <= IDLE;  
                end  
                ERROR: begin  
                    if (!error_detected)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
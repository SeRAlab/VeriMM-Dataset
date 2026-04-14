module sata_controller (  
    input clk,  
    input rst,  
    input start,  
    input error,  
    output reg [1:0] state  
);  
  
    // State encoding  
    parameter IDLE = 2'b00,  
              ACTIVE = 2'b01,  
              ERROR = 2'b10;  
  
    // State transition  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) state <= ACTIVE;  
                end  
                ACTIVE: begin  
                    if (error) state <= ERROR;  
                end  
                ERROR: begin  
                    if (!error) state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule
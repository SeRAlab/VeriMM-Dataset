module sata_controller (  
    input clk,  
    input reset,  
    input start,  
    input error,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               ACTIVE = 2'b01,  
               ERROR_STATE = 2'b10;  
               
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= ACTIVE;  
                end  
                ACTIVE: begin  
                    if (error)  
                        state <= ERROR_STATE;  
                end  
                ERROR_STATE: begin  
                    if (!error)  
                        state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule
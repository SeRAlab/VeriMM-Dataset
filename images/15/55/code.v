module sata_controller (  
    input clk,  
    input reset,  
    input [1:0] command,  
    output reg [1:0] state  
);  

    parameter IDLE = 2'b00;  
    parameter ACTIVE = 2'b01;  
    parameter ERROR = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (command == 2'b01)  
                        state <= ACTIVE;  
                    else  
                        state <= IDLE;  
                end  
                ACTIVE: begin  
                    if (command == 2'b10)  
                        state <= ERROR;  
                    else  
                        state <= IDLE;  
                end  
                ERROR: begin  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule
module pcie_control (  
    input clk,  
    input reset,  
    input request,  
    input [1:0] current_state, // 00: idle, 01: active, 10: error  
    output reg [1:0] next_state  
);  
    // State encoding  
    parameter IDLE = 2'b00;  
    parameter ACTIVE = 2'b01;  
    parameter ERROR = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            next_state <= IDLE;  
        end else begin  
            case (current_state)  
                IDLE: begin  
                    if (request)  
                        next_state <= ACTIVE;  
                    else  
                        next_state <= IDLE;  
                end  
                ACTIVE: begin  
                    if (request)  
                        next_state <= ERROR;  
                    else  
                        next_state <= ACTIVE;  
                end  
                ERROR: begin  
                    if (request)  
                        next_state <= IDLE;  
                    else  
                        next_state <= ERROR;  
                end  
                default: next_state <= IDLE;  
            endcase  
        end  
    end  
endmodule
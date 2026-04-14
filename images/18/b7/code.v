module sd_card_controller(  
    input clk,  
    input reset,  
    input start_read,  
    input start_write,  
    input error,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               READ = 2'b01,  
               WRITE = 2'b10,  
               ERROR_STATE = 2'b11;  
               
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_read)  
                        state <= READ;  
                    else if (start_write)  
                        state <= WRITE;  
                end  
                READ: begin  
                    if (error)  
                        state <= ERROR_STATE;  
                    else  
                        state <= IDLE;  
                end  
                WRITE: begin  
                    if (error)  
                        state <= ERROR_STATE;  
                    else  
                        state <= IDLE;  
                end  
                ERROR_STATE: begin  
                    // Stay in error state until reset  
                    if (reset)  
                        state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule
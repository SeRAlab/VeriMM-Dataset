module nvme_controller(  
    input clk,  
    input reset,  
    input read,  
    input write,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;  
   
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (read)  
                        state <= READ;  
                    else if (write)  
                        state <= WRITE;  
                end  
                READ:  
                    state <= IDLE;  
                WRITE:  
                    state <= IDLE;  
            endcase  
        end  
    end  
endmodule
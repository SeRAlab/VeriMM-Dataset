module nvme_controller(  
    input clk,  
    input reset,  
    input operation,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              READ = 2'b01,  
              WRITE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (operation)  
                        state <= WRITE;  
                    else if (!operation)  
                        state <= READ;  
                end  
                READ: begin  
                    state <= IDLE;  
                end  
                WRITE: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
module sata_controller(  
    input clk,  
    input reset,  
    input read,  
    input write,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              READ = 2'b01,  
              WRITE = 2'b10;  
  
    // Sequential logic for state transition  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (read)  
                        state <= READ;  
                    else if (write)  
                        state <= WRITE;  
                end  
                READ: begin  
                    // Simulate reading operation  
                    state <= IDLE;  
                end  
                WRITE: begin  
                    // Simulate writing operation  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
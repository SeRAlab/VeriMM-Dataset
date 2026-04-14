module dma_controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] mem_addr,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg busy,  
    output reg done  
);  
    reg [2:0] state;  
    parameter IDLE = 3'b000, READ = 3'b001, WRITE = 3'b010, COMPLETE = 3'b011;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            busy <= 0;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    busy <= 0;  
                    done <= 0;  
                    if (start) begin  
                        busy <= 1;  
                        state <= READ;  
                    end  
                end  
                READ: begin  
                    // Simulate reading data from memory  
                    data_out <= mem_addr; // Here we assume data_out is memory data  
                    state <= WRITE;  
                end  
                WRITE: begin  
                    // Simulate writing data to memory  
                    // In an actual design, this would involve more complex memory interactions  
                    state <= COMPLETE;  
                end  
                COMPLETE: begin  
                    busy <= 0;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
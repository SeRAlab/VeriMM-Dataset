module dma_controller(  
    input wire clk,  
    input wire rst_n,  
    input wire start,  
    input wire [7:0] src_addr,  
    input wire [7:0] dst_addr,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out,  
    output reg done  
);  
    reg [2:0] state;  
    parameter IDLE = 3'b000, READ = 3'b001, WRITE = 3'b010, DONE = 3'b011;  
    
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            state <= IDLE;  
            done <= 0;  
            data_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= READ;  
                        done <= 0;  
                    end  
                end  
                READ: begin  
                    data_out <= data_in;  
                    state <= WRITE;  
                end  
                WRITE: begin  
                    // Assume write operation is successful  
                    state <= DONE;  
                end  
                DONE: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
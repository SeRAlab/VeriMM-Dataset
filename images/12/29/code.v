module dma_controller(  
    input clk,  
    input rst,  
    input start,  
    input [7:0] src_addr,  
    input [7:0] dest_addr,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg done  
);  
    reg [2:0] state;  
    localparam IDLE = 3'b000, TRANSFER = 3'b001, DONE = 3'b010;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            done <= 0;  
            data_out <= 8'b0;  
        end else begin  
            case(state)  
                IDLE: begin  
                    if (start) begin  
                        state <= TRANSFER;  
                        data_out <= data_in;  
                    end  
                end  
                TRANSFER: begin  
                    // Simulate data transfer to destination address  
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
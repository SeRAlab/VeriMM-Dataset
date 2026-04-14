module dma_controller(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [31:0] src_addr,  
    input wire [31:0] dest_addr,  
    input wire [31:0] data_in,  
    output reg [31:0] data_out,  
    output reg done  
);  
    reg [2:0] state;  
    reg [2:0] byte_count;  
    parameter IDLE = 3'b000, TRANSFER = 3'b001, COMPLETE = 3'b010;  
      
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            byte_count <= 3'b000;  
            done <= 0;  
            data_out <= 32'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= TRANSFER;  
                        byte_count <= 3'b000;  
                        done <= 0;  
                    end  
                end  
                TRANSFER: begin  
                    data_out <= data_in; // Move data from src_addr to dest_addr  
                    byte_count <= byte_count + 1;  
                    if (byte_count == 3'b011) begin // After transferring 4 bytes  
                        state <= COMPLETE;  
                    end  
                end  
                COMPLETE: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
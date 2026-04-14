module dma_controller(  
    input clk,  
    input reset,  
    input start,  
    input [31:0] src_addr,  
    input [31:0] dest_addr,  
    input [31:0] data_in,  
    output reg ready,  
    output reg error,  
    output reg [31:0] data_out  
);  
    reg [1:0] state;  
    localparam IDLE = 2'b00, TRANSFER = 2'b01, COMPLETE = 2'b10;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            ready <= 1;  
            error <= 0;  
            data_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= TRANSFER;  
                        ready <= 0;  
                        error <= 0;  
                    end  
                end  
                TRANSFER: begin  
                    data_out <= data_in;  
                    // Simulate data transfer (in reality, you would write to memory)  
                    if (data_in === 32'hDEADBEEF) begin  
                        error <= 1;  
                        state <= COMPLETE;  
                    end else begin  
                        state <= COMPLETE;  
                    end  
                end  
                COMPLETE: begin  
                    ready <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
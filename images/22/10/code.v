module FlashMemoryCellController (  
    input wire clk,  
    input wire reset,  
    input wire write_en,  
    input wire read_en,  
    input wire erase_en,  
    input wire data_in,  
    output reg data_out  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, WRITE = 2'b01, READ = 2'b10, ERASE = 2'b11;  
    reg memory_cell;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            memory_cell <= 1'b0;  
            data_out <= 1'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (write_en) begin  
                        state <= WRITE;  
                    end else if (read_en) begin  
                        state <= READ;  
                    end else if (erase_en) begin  
                        state <= ERASE;  
                    end  
                end  
                WRITE: begin  
                    memory_cell <= data_in;  
                    data_out <= 1'b0;  
                    state <= IDLE;  
                end  
                READ: begin  
                    data_out <= memory_cell;  
                    state <= IDLE;  
                end  
                ERASE: begin  
                    memory_cell <= 1'b0;  
                    data_out <= 1'b0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
module dma_controller(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] src_addr,  
    input wire [7:0] dest_addr,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg busy  
);  

    reg [7:0] memory [255:0];  
    reg [7:0] current_addr;  
    reg [2:0] state;  

    localparam IDLE = 3'b000,  
               READ = 3'b001,  
               WRITE = 3'b010,  
               DONE = 3'b011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            busy <= 0;  
            state <= IDLE;  
            current_addr <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        current_addr <= src_addr;  
                        busy <= 1;  
                        state <= READ;  
                    end  
                end  
                READ: begin  
                    data_out <= memory[current_addr];  
                    current_addr <= current_addr + 1;  
                    if (current_addr == dest_addr)  
                        state <= DONE;  
                    else  
                        state <= WRITE;  
                end  
                WRITE: begin  
                    memory[current_addr] <= data_in;  
                    current_addr <= current_addr + 1;  
                    if (current_addr == dest_addr)  
                        state <= DONE;  
                    else  
                        state <= READ;  
                end  
                DONE: begin  
                    busy <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
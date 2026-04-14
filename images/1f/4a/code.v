module dma_controller(  
    input clk,  
    input reset,  
    input start,  
    input [7:0] src_addr,  
    input [7:0] dest_addr,  
    output reg read_enable,  
    output reg write_enable,  
    output reg [7:0] data_out  
);  

    reg [7:0] current_src;  
    reg [7:0] current_dest;  
    reg [3:0] state;  

    parameter IDLE = 0, READ = 1, WRITE = 2, DONE = 3;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_src <= 0;  
            current_dest <= 0;  
            read_enable <= 0;  
            write_enable <= 0;  
            data_out <= 0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        current_src <= src_addr;  
                        current_dest <= dest_addr;  
                        state <= READ;  
                    end  
                end  
                READ: begin  
                    read_enable <= 1;  
                    data_out <= current_src;  // Simulate data read  
                    state <= WRITE;  
                end  
                WRITE: begin  
                    write_enable <= 1;  
                    // Simulate data write to the address
                    current_dest <= data_out;  
                    state <= DONE;  
                end  
                DONE: begin  
                    read_enable <= 0;  
                    write_enable <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule
module dma_controller(  
    input clk,  
    input reset,  
    input start,  
    output reg [7:0] data_out,  
    output reg channel_sel  
);  
    reg [7:0] data_memory [0:255];  
    reg [7:0] address;  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            channel_sel <= 0;  
            data_out <= 0;  
            address <= 0;  
        end else if (start) begin  
            state <= state + 1;  
            channel_sel <= state[0];  
            data_out <= data_memory[address];  
            address <= address + 1;  
        end  
    end  
endmodule
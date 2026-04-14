module dma_controller(  
    input clk,  
    input reset,  
    input start,  
    input [7:0] src_addr,  
    input [7:0] dest_addr,  
    output reg [7:0] data_out,  
    output reg done  
);  
    reg [7:0] memory [0:255];  // Simple memory array for storage  
    reg [7:0] src_data;        // Register to hold source data  
    reg [7:0] dest_data;       // Register to hold destination data  
    reg transferring;           // State of the transfer  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            done <= 0;  
            transferring <= 0;  
        end else if (start && !transferring) begin  
            src_data <= memory[src_addr];  // Read data from source address  
            transferring <= 1;  
            done <= 0;  
        end else if (transferring) begin  
            memory[dest_addr] <= src_data;  // Write data to destination address  
            done <= 1;  
            transferring <= 0;  
        end  
    end  
endmodule
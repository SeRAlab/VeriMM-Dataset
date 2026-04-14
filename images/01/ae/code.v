module dma_controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] src_addr,  
    input wire [7:0] dest_addr,  
    input wire read_data,  
    output reg transfer_complete,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:255]; // Simple memory array  
    reg [7:0] src_data;  
    reg transferring;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            transfer_complete <= 0;  
            transferring <= 0;  
        end else if (start && !transferring) begin  
            transferring <= 1;  
            src_data <= memory[src_addr];  
        end else if (transferring) begin  
            data_out <= src_data;  
            memory[dest_addr] <= data_out;  
            transfer_complete <= 1;  
            transferring <= 0;  
        end  
    end  
endmodule
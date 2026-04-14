module dma_controller(  
    input clk,  
    input rst,  
    input start,  
    input [31:0] src_addr,  
    input [31:0] dest_addr,  
    input [7:0] num_words,  
    output reg transfer_complete,  
    output reg [31:0] data_out,  
    output reg addr_out_valid  
);  

    reg [7:0] count;  
    reg [31:0] current_src_addr;  
    reg [31:0] current_dest_addr;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 0;  
            transfer_complete <= 0;  
            addr_out_valid <= 0;  
            current_src_addr <= 0;  
            current_dest_addr <= 0;  
        end else if (start) begin  
            current_src_addr <= src_addr;  
            current_dest_addr <= dest_addr;  
            count <= num_words;  
            transfer_complete <= 0;  
            addr_out_valid <= 0;  
        end else if (count > 0) begin  
            // Simulate data transfer, in practice would read from memory  
            data_out <= current_src_addr;  // Mock reading from source  
            addr_out_valid <= 1;  
            current_src_addr <= current_src_addr + 4;  // Increment source address  
            current_dest_addr <= current_dest_addr + 4;  // Increment destination address  
            count <= count - 1;  
        end else begin  
            transfer_complete <= 1;  
            addr_out_valid <= 0;  
        end  
    end  
endmodule
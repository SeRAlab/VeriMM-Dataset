module dma_controller (  
    input wire clk,  
    input wire start,  
    input wire [7:0] src_addr,  
    input wire [7:0] dest_addr,  
    input wire [7:0] num_bytes,  
    output reg done  
);  
    reg [7:0] bytes_transferred;  
    reg [7:0] current_src;  
    reg [7:0] current_dest;  
    reg transferring;  

    always @(posedge clk) begin  
        if (start) begin  
            current_src <= src_addr;  
            current_dest <= dest_addr;  
            bytes_transferred <= 0;  
            transferring <= 1;  
            done <= 0;  
        end else if (transferring) begin  
            // Simulate data transfer
            if (bytes_transferred < num_bytes) begin  
                bytes_transferred <= bytes_transferred + 1;  
                current_src <= current_src + 1;  
                current_dest <= current_dest + 1;  
            end else begin  
                transferring <= 0;  
                done <= 1;  
            end  
        end  
    end  
endmodule
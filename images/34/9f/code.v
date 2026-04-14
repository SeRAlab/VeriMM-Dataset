module dma_controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [15:0] src_addr,  
    input wire [15:0] dest_addr,  
    input wire [7:0] count,  
    output reg busy,  
    output reg done,  
    output reg error  
);  

    reg [7:0] current_count;  
    reg [15:0] current_src;  
    reg [15:0] current_dest;  
    reg transferring;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            busy <= 0;  
            done <= 0;  
            error <= 0;  
            current_count <= 0;  
            transferring <= 0;  
        end else begin  
            if (start && !busy) begin  
                busy <= 1;  
                done <= 0;  
                error <= 0;  
                current_src <= src_addr;  
                current_dest <= dest_addr;  
                current_count <= count;  
                transferring <= 1;  
            end  
            if (transferring) begin  
                if (current_count > 0) begin  
                    // Simulate data transfer  
                    current_count <= current_count - 1;  
                end else begin  
                    busy <= 0;  
                    done <= 1;  
                    transferring <= 0;  
                end  
            end  
        end  
    end  
endmodule
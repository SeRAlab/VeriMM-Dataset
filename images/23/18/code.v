module dma_controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] src_address,  
    input wire [7:0] dest_address,  
    input wire [3:0] num_bytes,  
    output reg [7:0] data_out,  
    output reg done  
);  
    reg [3:0] byte_count;  
    reg [7:0] memory [255:0]; // Simulated memory  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            byte_count <= 0;  
            done <= 0;  
            data_out <= 0;  
        end else if (start && !done) begin  
            if (byte_count < num_bytes) begin  
                data_out <= memory[src_address + byte_count];  
                memory[dest_address + byte_count] <= data_out;  
                byte_count <= byte_count + 1;  
            end else begin  
                done <= 1;  
            end  
        end  
    end  
endmodule
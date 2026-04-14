module VirtualMemoryManager (  
    input clk,  
    input reset,  
    input [7:0] logical_address,  
    input valid_bit,  
    output reg [7:0] physical_address,  
    output reg error_signal  
);  
    reg [7:0] last_physical_address;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            physical_address <= 8'b0;  
            error_signal <= 1'b0;  
            last_physical_address <= 8'b0;  
        end else begin  
            if (valid_bit) begin  
                physical_address <= logical_address % 256;  
                last_physical_address <= physical_address;  
                error_signal <= 1'b0;  
            end else begin  
                physical_address <= 8'b0;  
                error_signal <= 1'b1;  
            end  
        end  
    end  
endmodule
module pcie_endpoint_controller(  
    input wire clk,  
    input wire [3:0] address,  
    input wire [31:0] data_in,  
    input wire command, // 0 for read, 1 for write  
    output reg [31:0] data_out  
);  
    reg [31:0] memory [15:0]; // Simple memory with 16 addresses  

    always @(posedge clk) begin  
        if (command) begin  
            // Write operation  
            memory[address] <= data_in;  
        end else begin  
            // Read operation  
            data_out <= memory[address];  
        end  
    end  
endmodule
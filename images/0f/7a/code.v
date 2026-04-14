module pcie_endpoint_controller(  
    input wire clk,  
    input wire reset,  
    input wire read_request,  
    input wire [7:0] address,  
    output reg [31:0] data_out  
);  

    reg [31:0] memory [0:255];  // Simple memory for storing data  

    // Initializing memory with some data  
    initial begin  
        memory[8'h00] = 32'hDEADBEEF;  
        memory[8'h01] = 32'hCAFECAFE;  
        memory[8'h02] = 32'hB16B00B5;  
        memory[8'h03] = 32'hBA5EBA11;  
        memory[8'h04] = 32'hABCDEF01;  
        // Add more initial values as needed  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 32'b0;  
        end else if (read_request) begin  
            data_out <= memory[address];  // Output data from the specified address  
        end  
    end  
endmodule
module dram_cell (  
    input wire clk,  
    input wire write_enable,  
    input wire read_enable,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  // 16-bit memory cell  

    always @(posedge clk) begin  
        if (write_enable) begin  
            memory <= data_in;  // Store input data on write enable  
        end  
        if (read_enable) begin  
            data_out <= memory;  // Output stored data on read enable  
        end  
    end  
endmodule
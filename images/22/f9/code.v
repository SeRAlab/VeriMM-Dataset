module dram_cell (  
    input wire clk,  
    input wire we,  
    input wire [3:0] data_in,  
    output reg [3:0] data_out,  
    input wire [1:0] addr  
);  
    reg [3:0] memory [0:3]; // 4-bit memory for 4 addresses  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data to memory  
        end  
        else begin  
            data_out <= memory[addr]; // Read data from memory  
        end  
    end  
endmodule
module dram_cell (  
    input wire [7:0] data_in,  
    input wire [2:0] addr,  
    input wire RE,  
    input wire WE,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:7]; // 8-bit DRAM cell with 8 addresses  

    always @(posedge WE) begin  
        memory[addr] <= data_in; // Write data to memory  
    end  

    always @(posedge RE) begin  
        data_out <= memory[addr]; // Read data from memory  
    end  
endmodule
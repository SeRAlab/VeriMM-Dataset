module sram_cell (  
    input wire [7:0] data_in,  
    input wire [2:0] addr,  
    input wire write_enable,  
    input wire chip_enable,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:7]; // 8-bit memory with 8 cells  

    always @(posedge chip_enable) begin  
        if (write_enable) begin  
            memory[addr] <= data_in; // Write operation  
        end  
        data_out <= memory[addr]; // Read operation  
    end  
endmodule
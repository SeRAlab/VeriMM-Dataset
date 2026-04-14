module sram_cell(  
    input [2:0] addr,  
    input [7:0] data_in,  
    input read_en,  
    input write_en,  
    output reg [7:0] data_out  
);  

    reg [7:0] memory [0:7]; // 8-bit memory with 8 addresses  

    always @(posedge write_en) begin  
        if (write_en) begin  
            memory[addr] <= data_in; // Write data to memory  
        end  
    end  

    always @(posedge read_en) begin  
        if (read_en) begin  
            data_out <= memory[addr]; // Read data from memory  
        end  
    end  
endmodule
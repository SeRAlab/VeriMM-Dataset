module eeprom_cell (  
    input wire clk,  
    input wire we,  
    input wire [2:0] addr,  
    input wire [4:0] data_in,  
    output reg [4:0] data_out  
);  
    reg [4:0] memory [0:7]; // 8 EEPROM cells, each 5 bits wide  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write data to memory  
        end else begin  
            data_out <= memory[addr]; // Read data from memory  
        end  
    end  
endmodule
module eeprom_cell(  
    input wire [4:0] addr,  
    input wire [7:0] data_in,  
    input wire we,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [31:0]; // 32 EEPROM cells, 8 bits each  
  
    always @(posedge we) begin  
        memory[addr] <= data_in; // Write data to the selected address  
    end  
  
    always @(negedge we) begin  
        data_out <= memory[addr]; // Output the data stored at the selected address  
    end  
endmodule
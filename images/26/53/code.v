module eeprom_cell (  
    input wire clk,  
    input wire we,  // Write enable  
    input wire re,  // Read enable  
    input wire erase,  // Erase signal  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  

    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (erase) begin  
            memory <= 8'b0;  // Erase memory  
        end else if (we) begin  
            memory <= data_in;  // Write data  
        end  
    end  

    always @(posedge clk) begin  
        if (re) begin  
            data_out <= memory;  // Read data  
        end  
    end  
endmodule
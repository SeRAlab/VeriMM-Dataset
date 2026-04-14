module eeprom_cell (  
    input wire D,  
    input wire WE,  
    input wire RE,  
    input wire RST,  
    output reg Q  
);  

always @(posedge RST) begin  
    Q <= 1'b0; // Reset the stored value  
end  

always @(posedge WE) begin  
    Q <= D; // Write data to EEPROM cell  
end  

always @(posedge RE) begin  
    // Read operation is a simple pass-through; Q already holds the stored value  
end  

endmodule
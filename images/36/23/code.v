module sram_cell (  
    input wire [3:0] data_in,  
    input wire [1:0] addr,  
    input wire we,  
    input wire ce,  
    input wire oe,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory [3:0]; // 4 cells of 4 bits each  

    always @(posedge we or negedge ce) begin  
        if (!ce)  
            data_out <= 4'bz; // High impedance when chip is disabled  
        else if (we)  
            memory[addr] <= data_in; // Write data to memory  
    end  

    always @(posedge oe or negedge ce) begin  
        if (!ce)  
            data_out <= 4'bz; // High impedance when chip is disabled  
        else if (!we)  
            data_out <= memory[addr]; // Read data from memory  
    end  
endmodule
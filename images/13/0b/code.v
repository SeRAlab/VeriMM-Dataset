module dram_cell (  
    input [2:0] addr,  
    input [7:0] data_in,  
    input we,  
    input re,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [0:7]; // 8-bit DRAM Cell with 8 addresses  

    always @(*) begin  
        if (we) begin  
            memory[addr] = data_in; // Write data to memory  
        end  
        if (re) begin  
            data_out = memory[addr]; // Read data from memory  
        end  
    end  
endmodule
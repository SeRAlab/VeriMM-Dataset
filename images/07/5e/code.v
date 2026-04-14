module sram_cell(  
    input wire [7:0] data_in,  
    input wire we,  
    input wire [2:0] addr,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [7:0]; // 8 locations of 8 bits each  

    always @(posedge we) begin  
        if (we)  
            memory[addr] <= data_in; // Write operation  
    end  

    always @(addr) begin  
        data_out <= memory[addr]; // Read operation  
    end  
endmodule
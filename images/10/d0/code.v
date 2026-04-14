module SRAM_16bit (  
    input wire [15:0] data_in,  
    input wire [3:0] addr,  
    input wire we,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [0:15]; // 16 16-bit SRAM cells  

    always @(posedge we) begin  
        if (we) begin  
            memory[addr] <= data_in; // Write operation  
        end  
    end  

    always @(addr) begin  
        data_out <= memory[addr]; // Read operation  
    end  
endmodule
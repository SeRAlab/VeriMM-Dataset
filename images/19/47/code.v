module sram_cell (  
    input wire [15:0] data_in,  
    input wire [3:0] addr,  
    input wire we,  
    input wire ce,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [15:0];  
  
    always @(posedge ce) begin  
        if (we)  
            memory[addr] <= data_in;  
        else  
            data_out <= memory[addr];  
    end  
endmodule
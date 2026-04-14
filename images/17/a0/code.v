module SRAM_16bit (  
    input wire we,  
    input wire re,  
    input wire ce,  
    input wire [3:0] addr,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  

    reg [15:0] memory [15:0]; // 16 words of 16 bits each  

    always @(*) begin  
        if (!ce) begin  
            data_out = 16'b0; // chip is disabled  
        end else if (re) begin  
            data_out = memory[addr]; // read data  
        end else if (we) begin  
            memory[addr] = data_in; // write data  
            data_out = 16'b0; // writing does not produce output  
        end else begin  
            data_out = 16'bz; // high impedance  
        end  
    end  
endmodule
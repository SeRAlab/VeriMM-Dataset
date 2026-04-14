module SRAM_16bit (  
    input wire clk,  
    input wire [3:0] addr,  
    input wire [15:0] data_in,  
    input wire write_enable,  
    input wire read,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [15:0]; // 16 x 16-bit SRAM cells  

    always @(posedge clk) begin  
        if (write_enable) begin  
            memory[addr] <= data_in; // Write data to the specified address  
        end  
    end  

    always @(*) begin  
        if (read) begin  
            data_out = memory[addr]; // Output data from the specified address  
        end else begin  
            data_out = 16'bz; // High impedance if not reading  
        end  
    end  
endmodule
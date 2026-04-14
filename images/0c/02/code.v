module sram_16bit (  
    input wire clk,  
    input wire [3:0] addr,  
    input wire [15:0] data_in,  
    input wire we,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [15:0]; // 16 x 16-bit SRAM cells  

    always @(posedge clk) begin  
        if (we) begin  
            memory[addr] <= data_in;  // Write operation  
        end  
        data_out <= memory[addr];    // Read operation  
    end  
endmodule
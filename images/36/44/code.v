module SRAM_16bit(  
    input wire [15:0] data_in,  
    input wire [3:0] addr,  
    input wire we,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory [15:0];  // 16 locations of 16-bit memory  

    always @(*) begin  
        if (we) begin  
            memory[addr] = data_in;  // Write operation  
        end else begin  
            data_out = memory[addr];  // Read operation  
        end  
    end  
endmodule
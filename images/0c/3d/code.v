module SRAM_Cell (  
    input [7:0] data_in,  
    input [2:0] addr,  
    input we,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory [7:0]; // 8 locations of 8 bits each  

    always @(posedge we) begin  
        memory[addr] <= data_in; // Write operation  
    end  

    always @(negedge we) begin  
        data_out <= memory[addr]; // Read operation  
    end  
endmodule
module SRAM_Cell (  
    input wire clk,  
    input wire we, // write enable  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  

    always @(posedge clk) begin  
        if (we)  
            memory <= data_in; // Write operation  
        else  
            data_out <= memory; // Read operation  
    end  
endmodule
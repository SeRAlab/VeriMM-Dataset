module DRAM_Cell (  
    input wire [3:0] data_in,  
    input wire control, // control: 1 for write, 0 for read  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @(posedge control) begin  
        if (control)  
            memory <= data_in;  // Write data  
        else  
            data_out <= memory;  // Read data  
    end  
endmodule
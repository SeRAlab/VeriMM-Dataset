module dram_cell (  
    input [15:0] data_in,  
    input RE,  
    input WE,  
    input CLK,  
    output reg [15:0] data_out  
);  
    reg [15:0] memory;  

    always @(posedge CLK) begin  
        if (WE)  
            memory <= data_in;  
        if (RE)  
            data_out <= memory;  
    end  
endmodule
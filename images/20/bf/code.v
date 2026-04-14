module dram_cell(  
    input wire [3:0] data_in,  
    input wire write,  
    input wire read,  
    output reg [3:0] data_out  
);  
    reg [3:0] storage;  

    always @(posedge write) begin  
        storage <= data_in;  
    end  

    always @(posedge read) begin  
        data_out <= storage;  
    end  
endmodule
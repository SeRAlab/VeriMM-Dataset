module sram_cell(  
    input wire [3:0] data_in,  
    input wire control,  
    output reg [3:0] data_out  
);  
    reg [3:0] memory;  

    always @ (posedge control) begin  
        memory <= data_in;  
    end  

    always @ (negedge control) begin  
        data_out <= memory;  
    end  
endmodule
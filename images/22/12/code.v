module dram_cell(  
    input we,  
    input re,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] memory;  

    always @(*) begin  
        if (we) begin  
            memory = data_in;  
        end  
    end  

    always @(re) begin  
        if (re) begin  
            data_out = memory;  
        end  
    end  
endmodule
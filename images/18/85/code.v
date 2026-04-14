module dram_cell (  
    input wire [3:0] data,  
    input wire we,  
    input wire re,  
    output reg [3:0] stored_data  
);  
    always @(*) begin  
        if (we)  
            stored_data = data;  
        else if (re)  
            stored_data = stored_data;  
    end  
endmodule
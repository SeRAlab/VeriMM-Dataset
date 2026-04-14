module flash_memory_cell(  
    input wire [3:0] data_in,  
    input wire write_en,  
    output reg [3:0] data_out  
);  
    always @(posedge write_en or negedge write_en) begin  
        if (write_en)  
            data_out <= data_in;  
    end  
endmodule
module dram_cell (  
    input wire [7:0] data_in,  
    input wire write_en,  
    output reg [7:0] data_out  
);  
    always @(posedge write_en or negedge write_en) begin  
        if (write_en)  
            data_out <= data_in;  
    end  
endmodule
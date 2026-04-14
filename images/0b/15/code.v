module sram_cell(  
    input wire [3:0] data,  
    input wire write_en,  
    input wire read_en,  
    output reg [3:0] stored_data  
);  
    always @(*) begin  
        if (read_en) begin  
            stored_data = stored_data; // Read operation  
        end else if (write_en) begin  
            stored_data = data; // Write operation  
        end  
    end  
endmodule
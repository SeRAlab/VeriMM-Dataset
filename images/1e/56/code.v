module flash_memory_cell (  
    input wire data_in,  
    input wire control,  
    output wire data_out  
);  
    reg stored_data;  
  
    always @(*) begin  
        if (control)  
            stored_data = data_in;  
    end  
  
    assign data_out = (control) ? data_in : stored_data;  
endmodule
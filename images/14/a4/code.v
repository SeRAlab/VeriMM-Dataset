module flash_memory_cell (  
    input [4:0] data_in,  
    input control,  
    output reg [4:0] data_out  
);  
    always @(*) begin  
        if (control)  
            data_out = data_in;  
        else  
            data_out = data_out;  
    end  
endmodule
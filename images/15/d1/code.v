module shift_register (  
    input clk,  
    input load,  
    input dir,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    always @(posedge clk) begin  
        if (load)  
            data_out <= data_in;  
        else if (dir)  
            data_out <= {data_out[14:0], 1'b0}; // Shift left  
        else  
            data_out <= {1'b0, data_out[15:1]}; // Shift right  
    end  
endmodule
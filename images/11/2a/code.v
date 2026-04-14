module shift_register(  
    input clk,  
    input load,  
    input shift,  
    input [1:0] data_in,  
    output reg [1:0] data_out  
);  
    always @(posedge clk) begin  
        if (load)  
            data_out <= data_in;  
        else if (shift)  
            data_out <= {data_out[0], 1'b0};  
    end  
endmodule
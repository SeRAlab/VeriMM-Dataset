module shift_register (  
    input clk,  
    input load,  
    input shift,  
    input [3:0] data_in,  
    output reg [3:0] reg_out  
);  
    always @(posedge clk) begin  
        if (load)  
            reg_out <= data_in;  
        else if (shift)  
            reg_out <= {1'b0, reg_out[3:1]};  
    end  
endmodule
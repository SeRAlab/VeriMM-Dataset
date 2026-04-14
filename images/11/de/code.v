module PIPO_Shift_Register(  
    input clk,  
    input load,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  
    always @(posedge clk) begin  
        if (load) begin  
            data_out <= data_in;  
        end  
        // No need to specify else case, it retains current value  
    end  
endmodule
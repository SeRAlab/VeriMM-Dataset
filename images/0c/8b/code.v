module pipo_shift_register(  
    input clk,  
    input enable,  
    input [4:0] data_in,  
    output reg [4:0] data_out  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            data_out <= data_in;  
        end  
    end  
endmodule
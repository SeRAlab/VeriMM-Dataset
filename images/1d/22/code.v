module shift_register (  
    input clk,  
    input enable,  
    input [1:0] data_in,  
    output reg [1:0] data_out  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            data_out <= {data_out[0], data_in[0]};  
        end  
    end  
endmodule
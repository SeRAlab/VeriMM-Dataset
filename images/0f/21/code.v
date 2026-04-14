module shift_register (  
    input clk,  
    input reset,  
    input enable,  
    input [1:0] data_in,  
    output reg [1:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 2'b00;  
        end else if (enable) begin  
            data_out <= {data_out[0], data_in[1]};  
        end  
    end  
endmodule
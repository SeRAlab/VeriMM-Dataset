module shift_register(  
    input clk,  
    input reset,  
    input shift_enable,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 8'b00000000;  
        end else if (shift_enable) begin  
            data_out <= {data_out[6:0], data_in[0]};  
        end  
    end  
endmodule
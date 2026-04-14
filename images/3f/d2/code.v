module shift_register (  
    input clk,  
    input reset,  
    input load_enable,  
    input shift_enable,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        data_out <= 16'b0;  
    end else if (load_enable) begin  
        data_out <= data_in;  
    end else if (shift_enable) begin  
        data_out <= {data_in[0], data_out[15:1]};  
    end  
end  
endmodule
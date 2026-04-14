module shift_register (  
    input clk,  
    input rst,  
    input enable,  
    input [3:0] data_in,  
    output reg [3:0] data_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_out <= 4'b0000;  
        end else if (enable) begin  
            data_out <= {data_out[2:0], data_in[0]};  
        end  
    end  
endmodule
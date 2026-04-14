module shift_register (  
    input clk,  
    input rst,  
    input load,  
    input shift_en,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            data_out <= 8'b0;  
        else if (load)  
            data_out <= data_in;  
        else if (shift_en)  
            data_out <= {1'b0, data_out[7:1]};  
    end  
endmodule
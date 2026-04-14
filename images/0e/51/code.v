module shift_register(  
    input clk,  
    input rst,  
    input shift_en,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_out <= 8'b00000000;  
        end else if (shift_en) begin  
            data_out <= {1'b0, data_out[7:1]};  
        end else begin  
            data_out <= data_out;  
        end  
    end  
endmodule
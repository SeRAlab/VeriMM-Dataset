module divide_by_2 (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            data_out <= 8'b0;  
        else  
            data_out <= data_in >> 1;  
    end  
endmodule
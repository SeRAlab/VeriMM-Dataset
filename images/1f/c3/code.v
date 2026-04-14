module PIPO_Shift_Register #(parameter WIDTH = 8) (  
    input wire clk,  
    input wire rst,  
    input wire load,  
    input wire [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            data_out <= 0;  
        else if (load)  
            data_out <= data_in;  
        else  
            data_out <= {data_out[WIDTH-2:0], 1'b0};  
    end  
endmodule
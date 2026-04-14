module divide_by_8(input [2:0] data_in, input clk, input reset, output reg [2:0] data_out);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            data_out <= 3'b000;  
        else  
            data_out <= data_in >> 3;  
    end  
endmodule
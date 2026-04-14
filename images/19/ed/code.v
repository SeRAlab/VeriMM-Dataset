module deadbeat_controller(clk, rst, input_signal, output_signal);  
    input clk;  
    input rst;  
    input [3:0] input_signal;  
    output reg [3:0] output_signal;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            output_signal <= 4'b0000;  
        else  
            output_signal <= input_signal;  
    end  
endmodule
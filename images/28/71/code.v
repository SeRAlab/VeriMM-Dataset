module reset_controller(  
    input wire clk,  
    input wire reset,  
    input wire data_in,  
    output reg data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            data_out <= 1'b0;  
        else  
            data_out <= data_in;  
    end  
endmodule
module reset_controller(  
    input wire clk,  
    input wire rst_n,  
    input wire data_in,  
    output reg data_out  
);  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            data_out <= 1'b0;  
        else  
            data_out <= data_in;  
    end  
endmodule
module reset_controller(  
    input wire clk,  
    input wire reset_n,  
    output reg reset_out  
);  
    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n)  
            reset_out <= 1'b1;  
        else  
            reset_out <= 1'b0;  
    end  
endmodule
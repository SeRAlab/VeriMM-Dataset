module reset_controller(  
    input wire clk,  
    input wire reset_n,  
    output reg reset_out  
);  

    reg [1:0] debounce;  

    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            reset_out <= 1'b0;  
            debounce <= 2'b00;  
        end else begin  
            if (debounce == 2'b11)  
                reset_out <= 1'b1;  
            else  
                debounce <= debounce + 1;  
        end  
    end  
endmodule
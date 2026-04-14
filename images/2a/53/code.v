module power_gating_control(  
    input [1:0] state,  
    output reg control  
);  
    always @(*) begin  
        if (state == 2'b11)  
            control = 1'b1;  
        else  
            control = 1'b0;  
    end  
endmodule
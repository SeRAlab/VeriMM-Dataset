module dvfs_controller(  
    input [1:0] voltage,  
    input [2:0] frequency,  
    output reg enable  
);  
    always @(*) begin  
        if (voltage == 2'b11 && frequency >= 3'b100)  
            enable = 1'b1;  
        else  
            enable = 1'b0;  
    end  
endmodule
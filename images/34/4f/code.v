module shift_register_2bit(  
    input clk,  
    input rst,  
    input SI,  
    output reg [1:0] Q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            Q <= 2'b00;  
        else  
            Q <= {Q[0], SI};  
    end  
endmodule
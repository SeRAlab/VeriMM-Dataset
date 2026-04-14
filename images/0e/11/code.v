module shift_register(  
    input clk,  
    input rst,  
    input data_in,  
    output reg [3:0] q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            q <= 4'b0000;  
        else  
            q <= {q[2:0], data_in};  
    end  
endmodule
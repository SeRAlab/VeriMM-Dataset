module shift_register (  
    input clk,  
    input rst,  
    input serial_in,  
    output reg [1:0] q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            q <= 2'b00;  
        else  
            q <= {q[0], serial_in};  
    end  
endmodule
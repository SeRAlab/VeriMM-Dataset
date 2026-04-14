module shift_register (  
    input clk,  
    input reset,  
    output reg [1:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            q <= 2'b00;  
        else  
            q <= {1'b0, q[1]};  
    end  
endmodule
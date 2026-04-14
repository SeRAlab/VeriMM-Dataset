module shift_register(  
    input clk,  
    input reset,  
    input control,  
    output reg [1:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            q <= 2'b00;  
        else if (control)  
            q <= {1'b0, q[1]};  // Shift right  
        else  
            q <= {q[0], 1'b0};  // Shift left  
    end  
endmodule
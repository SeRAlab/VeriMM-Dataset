module shift_register (  
    input clk,  
    input reset,  
    input load,  
    input shift,  
    input [3:0] data_in,  
    output reg [3:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            q <= 4'b0000;  
        else if (load)  
            q <= data_in;  
        else if (shift)  
            q <= {q[2:0], 1'b0};  
    end  
endmodule
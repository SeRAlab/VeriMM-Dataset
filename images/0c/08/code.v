module shift_register (  
    input clk,  
    input load,  
    input reset,  
    input [3:0] data,  
    output reg [3:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            q <= 4'b0000;  
        else if (load)  
            q <= data;  
        else  
            q <= {q[2:0], 1'b0};  
    end  
endmodule
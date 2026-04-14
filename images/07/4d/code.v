module shift_register(  
    input clk,  
    input reset,  
    input load,  
    input [1:0] data_in,  
    output reg [1:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            q <= 2'b00;  
        else if (load)  
            q <= data_in;  
        else  
            q <= {q[0], 1'b0};  
    end  
endmodule
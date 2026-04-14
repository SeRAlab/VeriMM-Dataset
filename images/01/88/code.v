module shift_register (  
    input clk,  
    input reset,  
    input data_in,  
    output reg [3:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            q <= 4'b0000;  
        end else begin  
            q <= {q[2:0], data_in};  
        end  
    end  
endmodule
module shift_register (  
    input clk,  
    input reset,  
    input shift_right,  
    input load,  
    input [7:0] parallel_in,  
    output reg [7:0] q  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            q <= 8'b0;  
        end else if (load) begin  
            q <= parallel_in;  
        end else if (shift_right) begin  
            q <= {1'b0, q[7:1]};  
        end else begin  
            q <= {q[6:0], 1'b0};  
        end  
    end  
endmodule
module shift_register(  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    input load,  
    input shift,  
    output reg [3:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            q <= 4'b0000;  
        end else if (load) begin  
            q <= data_in;  
        end else if (shift) begin  
            q <= {1'b0, q[3:1]};  
        end  
    end  
endmodule
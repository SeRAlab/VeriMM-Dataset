module shift_register(  
    input clk,  
    input reset,  
    input load,  
    input [1:0] data_in,  
    output reg [1:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            q <= 2'b00;  
        end else if (load) begin  
            q <= data_in;  
        end else begin  
            q <= {q[0], 1'b0};  
        end  
    end  
endmodule
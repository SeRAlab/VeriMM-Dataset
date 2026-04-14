module shift_register (  
    input clk,  
    input rst,  
    input [7:0] d,  
    output reg [7:0] q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            q <= 8'b00000000;  
        end else begin  
            q <= {q[6:0], 1'b0}; // Left shift operation  
        end  
    end  
endmodule
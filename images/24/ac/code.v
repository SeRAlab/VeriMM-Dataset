module shift_register_2bit (  
    input clk,  
    input rst,  
    input SI,  
    output reg [1:0] Q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            Q <= 2'b00;  
        end else begin  
            Q <= {SI, Q[1]};  
        end  
    end  
endmodule
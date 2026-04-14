module shift_register (  
    input clk,  
    input rst,  
    input load,  
    input [3:0] parallel_in,  
    output reg [3:0] shift_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_out <= 4'b0000;  
        end else if (load) begin  
            shift_out <= parallel_in;  
        end else begin  
            shift_out <= {1'b0, shift_out[3:1]};  
        end  
    end  
endmodule
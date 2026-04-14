module shift_register(  
    input clk,  
    input rst,  
    input [15:0] d_in,  
    input shift_dir,  
    output reg [15:0] d_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            d_out <= 16'b0;  
        end else begin  
            if (shift_dir == 1'b0) begin  // Shift left  
                d_out <= {d_out[14:0], 1'b0};  
            end else begin  // Shift right  
                d_out <= {1'b0, d_out[15:1]};  
            end  
        end  
    end  
endmodule
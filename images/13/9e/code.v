module shift_register (  
    input clk,  
    input rst,  
    input load,  
    input [7:0] data_in,  
    output reg [7:0] q  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            q <= 8'b0;  
        end else if (load) begin  
            q <= data_in;  
        end else begin  
            q <= {1'b0, q[7:1]}; // Shift right with zero fill  
        end  
    end  
endmodule
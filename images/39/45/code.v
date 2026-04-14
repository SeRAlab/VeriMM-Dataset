module ring_counter(  
    input clk,  
    input reset,  
    output reg [4:0] count  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 5'b00001;  // Initialize to a specific state  
        end else begin  
            count <= {count[3:0], count[4]};  // Shift left, maintaining ring behavior  
        end  
    end  
endmodule
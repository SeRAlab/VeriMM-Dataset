module divide_by_8(  
    input wire clk,  
    input wire reset,  
    input wire [2:0] dividend,  
    output reg [4:0] quotient  
);  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 5'b0;  
        end else begin  
            quotient <= {2'b00, dividend}; // Since we're dividing by 8, we only need the 3-bit input shifted left by 2 bits  
        end  
    end  
endmodule
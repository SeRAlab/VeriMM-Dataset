module adaptive_lms_filter(  
    input clk,  
    input rst,  
    input [15:0] x,      // Input signal  
    input [15:0] d,      // Desired signal  
    input [15:0] mu,     // Step size  
    output reg [15:0] y, // Output signal  
    output reg [15:0] w  // Updated weights  
);  
    reg [15:0] error;  
    reg [15:0] product;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y <= 16'b0;  
            w <= 16'b0;  
        end else begin  
            y <= w * x; // Output signal calculation  
            error <= d - y; // Error calculation  
            product <= mu * error * x; // Update product  
            w <= w + product; // Update weights  
        end  
    end  
endmodule
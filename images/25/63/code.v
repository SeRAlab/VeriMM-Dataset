module rgb_to_grayscale (  
    input [7:0] A, // Red  
    input [7:0] B, // Green  
    input [7:0] C, // Blue  
    output reg [7:0] gray  
);  
    always @(*) begin  
        gray = (A * 299 + B * 587 + C * 114) / 1000;  
    end  
endmodule
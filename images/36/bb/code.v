module DCT_1D(input [7:0] x_in, output reg [7:0] y_out);  
    always @(*) begin  
        // Simplified DCT calculation for demonstration  
        y_out = (x_in * 2) >> 1; // Example transformation for DCT  
    end  
endmodule
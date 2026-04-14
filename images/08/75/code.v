module decoder4to16 (  
    input [3:0] in,  
    output reg [15:0] out  
);  
    always @(*) begin  
        out = 16'b0000000000000000; // Initialize output to 0  
        out[in] = 1'b1; // Set the output corresponding to the input  
    end  
endmodule
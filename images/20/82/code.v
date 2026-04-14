module decoder_4_to_16 (  
    input [3:0] in,  
    output reg [15:0] out  
);  
    always @(*) begin  
        out = 16'b0000000000000000; // Reset all outputs  
        out[in] = 1'b1; // Set the output corresponding to the input  
    end  
endmodule
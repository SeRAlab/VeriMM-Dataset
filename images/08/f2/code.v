module decoder_5to32 (  
    input [4:0] binary_in,  
    output reg [31:0] decoded_out  
);  
    always @(*) begin  
        decoded_out = 32'b0; // Initialize all outputs to 0  
        decoded_out[binary_in] = 1'b1; // Set the appropriate output high  
    end  
endmodule
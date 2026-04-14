module decoder_4to16(  
    input [3:0] in,  
    output reg [15:0] out  
);  
    always @(*) begin  
        out = 16'b0; // Set all outputs to low  
        out[in] = 1'b1; // Set the corresponding output high  
    end  
endmodule
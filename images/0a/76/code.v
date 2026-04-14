module decoder_5_to_32 (  
    input [4:0] in,  
    output reg [31:0] out  
);  
    always @(*) begin  
        out = 32'b0;  
        out[in] = 1'b1;  
    end  
endmodule
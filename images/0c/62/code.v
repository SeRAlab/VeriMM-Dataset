module priority_encoder(  
    input [4:0] in,  
    output reg [2:0] out  
);  
    always @(*) begin  
        casez (in)  
            5'b1xxxx: out = 3'd0; // Input 0  
            5'b01xxx: out = 3'd1; // Input 1  
            5'b001xx: out = 3'd2; // Input 2  
            5'b0001x: out = 3'd3; // Input 3  
            5'b00001: out = 3'd4; // Input 4  
            default: out = 3'b111; // No active inputs  
        endcase  
    end  
endmodule
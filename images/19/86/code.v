module noise_suppression (  
    input [4:0] in,  
    output reg [4:0] out  
);  
    always @(*) begin  
        out = 5'b00000;  
        // Count the number of '1's  
        if ((in[0] + in[1] + in[2] + in[3] + in[4]) > 2) begin  
            out = 5'b11111;  
        end else begin  
            out = 5'b00000;  
        end  
    end  
endmodule
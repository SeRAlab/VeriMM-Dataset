module mux4to1_with_forwarding (  
    input [3:0] A, B, C, D,  
    input [1:0] S,  
    output reg [3:0] Y  
);  
    reg [3:0] prev_Y;  
    always @(*) begin  
        case (S)  
            2'b00: Y = A;  
            2'b01: Y = B;  
            2'b10: Y = C;  
            2'b11: Y = D;  
            default: Y = 4'b0000;  
        endcase  
        // Data forwarding logic  
        if (Y == prev_Y) begin  
            Y = prev_Y;  
        end  
        prev_Y = Y;  
    end  
endmodule
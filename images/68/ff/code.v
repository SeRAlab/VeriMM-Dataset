module top_module(S, T, Y_hi, Y_lo, C, V, N, Z);input [31:0] S, T;
    output reg [31:0] Y_hi, Y_lo;
    output reg C, V, N, Z;
    
    integer int_s, int_t;
    
    
    always @ (*) begin
        
        int_s = S;
        int_t = T;
        Y_lo = int_s / int_t; 
        Y_hi = int_s % int_t; 
        
        
        C = 1'bx;
        V = 1'bx;
        N = Y_lo[31];
        Z = (Y_lo == 32'h0)? 1'b1 : 1'b0;
    end

    
    
endmodule
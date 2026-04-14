module non_restoring_divider (  
    input [3:0] A, // Dividend  
    input [3:0] B, // Divisor  
    output reg [3:0] Q, // Quotient  
    output reg [3:0] R // Remainder  
);  
    reg [3:0] M; // Current value of divisor  
    reg [4:0] D; // Current value of dividend  
    integer i;  

    always @(*) begin  
        Q = 0;  
        R = 0;  
        D = {1'b0, A}; // Initial Dividend (5 bits)  
        M = B; // Initialize M with divisor  

        for (i = 0; i < 4; i = i + 1) begin  
            D = D << 1; // Shift D left  
            if (D >= M) begin  
                D = D - M; // Subtract M from D  
                Q = Q | (1'b1 << (3 - i)); // Set bit in quotient  
            end  
        end  
        R = D[3:0]; // Remainder is the last 4 bits of D  
    end  
endmodule
module booth_multiplier (
    input [7:0] A, // Multiplicand
    input [7:0] B, // Multiplier
    output reg [15:0] P // Product
);
    reg [15:0] A_ext, B_ext;
    reg [8:0] Q; // Q with extra bit for Booth's algorithm
    reg [7:0] M; // Q
    reg [15:0] P_temp;
    integer i;

    always @(*) begin
        A_ext = {8'b0, A}; // Extend A to 16 bits
        B_ext = {8'b0, B}; // Extend B to 16 bits
        Q = {1'b0, B}; // Initialize Q with B and zero extended
        M = A; // Set M to the multiplicand
        P_temp = 16'b0; // Initialize product to zero

        for (i = 0; i < 8; i = i + 1) begin
            case (Q[1:0])
                2'b01: P_temp = P_temp + A_ext; // Add M
                2'b10: P_temp = P_temp - A_ext; // Subtract M
            endcase
            // Arithmetic right shift
            P_temp = {P_temp[15], P_temp[15:1]};
            Q = {P_temp[0], Q[8:1]}; // Update Q
        end
        P = P_temp; // Final product
    end
endmodule
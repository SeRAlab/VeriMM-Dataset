module booth_multiplier (
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);
    reg [3:0] Q;
    reg Qn;
    reg [4:0] A_ext;
    reg [4:0] P_ext;
    integer i;

    always @(*) begin
        // Initialize
        A_ext = {1'b0, A}; // A is extended to 5 bits
        P_ext = {1'b0, B, 1'b0}; // P is initialized to B and extended to 5 bits
        Q = 4'b0000; // Initialize Q

        for (i = 0; i < 4; i = i + 1) begin
            case ({P_ext[0], Qn})
                2'b01: P_ext = P_ext + A_ext; // Add A to P
                2'b10: P_ext = P_ext - A_ext; // Subtract A from P
            endcase

            // Arithmetic right shift
            Qn = P_ext[0];
            P_ext = {P_ext[4], P_ext[4:1]};
            P_ext[0] = Q[3]; // Last bit of Q to the LSB of P
            Q = {P_ext[4], Q[3:1]}; // Q gets the new MSB from P
        end

        P = P_ext[3:0]; // Output the resulting product
    end
endmodule
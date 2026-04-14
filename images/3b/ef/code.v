module ShiftRows(
    input [127:0] state_in,
    output reg [127:0] state_out
);
    always @(*) begin
        state_out[127:120] = state_in[127:120]; // Row 0 (no shift)
        state_out[119:112] = state_in[111:104]; // Row 1 (shift left by 1)
        state_out[111:104] = state_in[95:88];   // Row 2 (shift left by 2)
        state_out[103:96]  = state_in[79:72];   // Row 2 (shift left by 2)
        state_out[95:88]   = state_in[63:56];   // Row 3 (shift left by 3)
        state_out[87:80]   = state_in[47:40];   // Row 3 (shift left by 3)
        state_out[79:72]   = state_in[31:24];   // Row 3 (shift left by 3)
        state_out[71:64]   = state_in[15:8];    // Row 3 (shift left by 3)
        state_out[63:56]   = state_in[127:120]; // Row 0 (no shift)
    end
endmodule
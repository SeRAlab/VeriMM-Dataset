module xor_gate (
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg XOR_output
);

    always @(*) begin
        XOR_output = VPB ^ VNB;
    end

endmodule
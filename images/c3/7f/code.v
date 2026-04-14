module xor_gate (
    input A,
    input B,
    input EN,
    input CLK,
    output reg Z
);

    always @(posedge CLK) begin
        if (EN) begin
            Z <= A ^ B;
        end else begin
            Z <= 0;
        end
    end

endmodule
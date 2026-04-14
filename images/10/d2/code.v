module D_flip_flop (
    input wire D,
    input wire CLK,
    input wire RST,
    output reg Q
);
    wire S, R;

    assign S = D & ~RST;      // Set condition
    assign R = ~D & RST;      // Reset condition

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 0;           // Reset output Q to 0
        end else begin
            Q <= S;           // Transfer D to Q
        end
    end
endmodule
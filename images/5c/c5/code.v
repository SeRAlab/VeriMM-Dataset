module top_module(
    output reg Q,
    output wire Q_N,
    input CLK,
    input D,
    input RESET_B
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // D Flip-Flop with active low reset
    always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 1'b0; // Reset output to 0 on active low reset
        end else begin
            Q <= D; // Transfer D to Q on clock edge
        end
    end

    // Inverted output
    assign Q_N = ~Q;

endmodule
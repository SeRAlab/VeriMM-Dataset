module top_module(
    input CLK,
    input D,
    input RESET_B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Q
);// Local signals
    wire buf_Q;
    wire RESET;

    // Invert RESET_B signal
    assign RESET = ~RESET_B;

    // D flip-flop with asynchronous reset
    always @(posedge CLK, negedge RESET) begin
        if (~RESET) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end

endmodule
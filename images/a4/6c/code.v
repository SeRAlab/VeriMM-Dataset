module top_module(
    output reg Q,  // Changed to reg since we use it in an always block
    input CLK_N,
    input D,
    input RESET_B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);always @(posedge CLK_N or negedge RESET_B) begin
        if (RESET_B == 1'b0) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end

endmodule
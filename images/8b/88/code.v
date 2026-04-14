module top_module(
    input D,
    input SCD,
    input SCE,
    input GATE,
    input CLK,
    input RESET,
    output reg Q,  // Changed to output reg
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);always @(posedge CLK or negedge RESET) begin
        if (!RESET) begin
            Q <= 1'b0;
        end else if (GATE) begin
            if (SCD) begin
                Q <= 1'b0;
            end else if (SCE) begin
                Q <= D;
            end
        end
    end

endmodule
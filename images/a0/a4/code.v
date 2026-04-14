module top_module(
    output reg Q,
    input CLK,
    input D,
    input SCD,
    input SCE,
    input SET_B
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Register to hold the D flip-flop value
    always @(posedge CLK or negedge SET_B) begin
        if (!SET_B) begin
            Q <= 1'b0; // Active-low reset
        end else if (SCE) begin
            Q <= SCD; // Set value
        end else begin
            Q <= D; // Normal D flip-flop behavior
        end
    end

endmodule
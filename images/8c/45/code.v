module top_module(
    input CLK,
    input D,
    output reg Q,
    input SCD,
    input SCE,
    input SET_B,
    input VPWR,
    input VGND
);// Replace the sky130_fd_sc_hs__sdfstp with a behavioral implementation
    always @(posedge CLK) begin
        if (SCD) begin
            Q <= 0;              // Clear output when SCD is high
        end else if (SCE) begin
            Q <= 1;              // Set output to 1 when SCE is high
        end else if (~SET_B) begin
            Q <= 0;              // Clear output when SET_B is low
        end else begin
            if (D) begin
                Q <= 1;          // Set output to 1 when D is high
            end else begin
                Q <= 0;          // Set output to 0 when D is low
            end
        end
    end

endmodule
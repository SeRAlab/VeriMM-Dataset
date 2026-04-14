module top_module(
    input logic A1,
    input logic A2,
    input logic B1,
    input logic B2,
    input logic C1,
    output logic Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    always_comb begin
        if (A1 && A2) begin
            Y = 1;
        end
        else if (B1 && B2) begin
            Y = 1;
        end
        else if (C1) begin
            Y = 0;
        end
        else begin
            Y = 0;
        end
    end

endmodule
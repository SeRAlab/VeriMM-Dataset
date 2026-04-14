module top_module(
    input A,
    input B,
    input C,
    input D,
    output reg Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    always @ (A or B or C or D) begin
        Y = ~(A & B & C & D);
    end

endmodule
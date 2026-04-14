module top_module(
    output reg X,  // Changed to output reg
    input A1,
    input A2,
    input A3,
    input B1,
    input C1
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    always @(*) begin
        if (A1 && !A2) begin
            X <= B1;
        end else if (!A1 && A2) begin
            X <= C1;
        end else if (A1 && A2) begin
            X <= A3;
        end else begin
            X <= 0;
        end
    end

endmodule
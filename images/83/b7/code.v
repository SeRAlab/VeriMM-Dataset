module top_module(
    input wire RESET_B,
    input wire D,
    input wire VPWR,
    input wire VGND,
    input wire VPB,
    input wire VNB,
    input wire GATE,
    output reg Q,
    output reg Q_N
);reg Q_int;
    always @ (posedge GATE) begin
        if (!RESET_B) begin
            Q_int <= 1'b0;
        end else if (D) begin
            Q_int <= 1'b1;
        end
    end

    assign Q = Q_int;
    assign Q_N = ~Q_int;

endmodule
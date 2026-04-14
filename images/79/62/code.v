module top_module(
    input  wire RESET_B,
    input  wire D,
    input  wire VPWR,
    input  wire VGND,
    input  wire VPB,
    input  wire VNB,
    output wire Q,
    input  wire GATE
);reg Q_reg;

    always @(posedge GATE) begin
        if (!RESET_B) begin
            Q_reg <= 1'b0;
        end
        else begin
            if (D) begin
                Q_reg <= 1'b1;
            end
            else begin
                Q_reg <= VPWR;
            end
        end
    end

    assign Q = Q_reg;

endmodule
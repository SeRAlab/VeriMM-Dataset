module top_module(
    Y,
    A
);output Y;
    input  A;

    // Voltage supply signals
    supply1 VPWR ;
    supply0 VGND ;
    supply1 KAPWR;
    supply1 VPB  ;
    supply0 VNB  ;

    // Enable signal for clock gating
    reg enable;
    always @(posedge A) begin
        if (A == enable) begin
            enable <= 0;
        end else begin
            enable <= 1;
        end
    end

    // Inverter circuit with clock gating
    reg Y_reg;
    always @(posedge VPWR or posedge enable) begin
        if (enable) begin
            Y_reg <= ~A;
        end
    end
    assign Y = Y_reg;

endmodule
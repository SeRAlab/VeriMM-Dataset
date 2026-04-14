module top_module(
    input CLK,
    input D,
    input SCD,
    input SCE,
    input SET_B,
    output reg Q,
    output reg Q_N
);wire mux_out;
    reg T;

    assign mux_out = (SCE == 1'b0) ? D : T;

    always @(posedge CLK) begin
        if (SCD == 1'b1) begin
            if (SCE == 1'b0) begin
                Q <= mux_out;
            end else begin
                Q <= (D == 1'b1) ? ~Q : Q;
            end
            Q_N <= ~Q;
        end
    end

    always @(posedge CLK) begin
        if (SET_B == 1'b1) begin
            T <= 1'b1;
        end else begin
            T <= 1'b0;
        end
    end

endmodule
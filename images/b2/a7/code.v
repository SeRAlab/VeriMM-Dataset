module top_module(
    input I,
    input IB,
    input IBUFDISABLE,
    output O,
    output OB
);parameter DIFF_TERM = 0;
    parameter DQS_BIAS = 0;
    parameter IBUF_LOW_PWR = 1;
    parameter IOSTANDARD = "DEFAULT";
    parameter SIM_DEVICE = "7SERIES";
    parameter USE_IBUFDISABLE = 1;

    wire out_val;
    wire out_b_val;
    reg o_out;

    assign out_val = (SIM_DEVICE == "7SERIES") ? 1'b1 : 1'b0;
    assign out_b_val = (SIM_DEVICE == "7SERIES") ? 1'b1 : 1'bx;

    assign O = (USE_IBUFDISABLE == 1) ? ((IBUFDISABLE == 0) ? o_out : ((IBUFDISABLE == 1) ? out_val : 1'bx)) : o_out;
    assign OB = (USE_IBUFDISABLE == 1) ? ((IBUFDISABLE == 0) ? ~o_out : ((IBUFDISABLE == 1) ? out_b_val : 1'bx)) : ~o_out;

    always @ (I, IB, DIFF_TERM, DQS_BIAS, IBUF_LOW_PWR) begin
        if (I == 1'b1 && IB == 1'b0) begin
            o_out <= I;
        end else if (I == 1'b0 && IB == 1'b1) begin
            o_out <= I;
        end else if ((I === 1'bz || I == 1'b0) && (IB === 1'bz || IB == 1'b1)) begin
            if (DQS_BIAS == 1'b1) begin
                o_out <= 1'b0;
            end else begin
                o_out <= 1'bx;
            end
        end else if (I === 1'bx || IB === 1'bx) begin
            o_out <= 1'bx;
        end
    end

endmodule
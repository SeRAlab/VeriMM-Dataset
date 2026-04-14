module top_module(
    input CLK_24M,
    input RESETP,
    output CLK_24MB,
    output LSPC_12M,
    output LSPC_8M,
    output LSPC_6M,
    output LSPC_4M,
    output LSPC_3M,
    output LSPC_1_5M,
    output Q53_CO
);assign CLK_24MB = ~CLK_24M;

    // D flip-flop with asynchronous active-low reset
    reg R262_Q, R262_nQ, R268_Q;
    always @(posedge CLK_24M or negedge RESETP) begin
        if (!RESETP) begin
            R262_Q <= 0;
            R262_nQ <= 1;
            R268_Q <= 0;
        end else begin
            R262_Q <= R268_Q;
            R262_nQ <= ~R268_Q;
            R268_Q <= R262_nQ;
        end
    end

    // D flip-flop with asynchronous active-high reset
    reg S219A_nQ;
    always @(posedge LSPC_8M or negedge RESETP) begin
        if (!RESETP) begin
            S219A_nQ <= 1;
        end else begin
            S219A_nQ <= ~S219A_nQ;
        end
    end

    // XOR gate
    assign Q53_CO = R262_Q ^ R262_nQ;

    // Inverter
    assign LSPC_1_5M = ~R262_Q;

    // 2-bit counter with asynchronous active-low reset
    reg [1:0] counter;
    always @(posedge LSPC_3M or negedge RESETP) begin
        if (!RESETP) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    // Mux
    assign LSPC_6M = (counter == 2'b00) ? 1 : 0;
    assign LSPC_4M = (counter == 2'b01) ? 1 : 0;
    assign LSPC_12M = (counter == 2'b10) ? 1 : 0;

    // AND gate
    assign LSPC_8M = ~(R262_Q & R262_nQ);

endmodule
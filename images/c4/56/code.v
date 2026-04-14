module delay_reset_controller (
    input CLK_IN,
    input reset,
    input enb_1_2000_0,
    input Reset_1,
    input signed [31:0] In,
    output reg signed [31:0] Out
);

    reg signed [31:0] In_Delay_out1;  // sfix32_En27

    always @(posedge CLK_IN) begin
        if (reset) begin
            Out <= 0;
        end else if (enb_1_2000_0) begin
            Out <= In;
        end
    end

    always @(posedge CLK_IN) begin
        if (Reset_1) begin
            Out <= 0;
        end else begin
            In_Delay_out1 <= Out;
            Out <= In_Delay_out1;
        end
    end

endmodule
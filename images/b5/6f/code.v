module top_module(
    input SCE,
    input GATE,
    input CLK,
    input VPWR,
    output reg GCLK
);// Local signals
    reg m0;
    wire m0n;
    wire clkn;
    reg [1:0] SCE_delayed;
    reg [1:0] GATE_delayed;
    reg [1:0] CLK_delayed;
    wire SCE_gate_delayed;
    reg notifier;
    reg awake;          // Change to reg type
    reg SCE_awake;      // Change to reg type
    reg GATE_awake;     // Change to reg type

    // Delayed inputs
    always @(posedge CLK) begin
        SCE_delayed <= {SCE_delayed[0], SCE};
        GATE_delayed <= {GATE_delayed[0], GATE};
        CLK_delayed <= {CLK_delayed[0], CLK};
    end

    // Inverter and clock delay
    assign m0n = ~m0;
    assign clkn = ~CLK_delayed[1]; // Change to access the correct delayed CLK

    // AND gate for D-latch
    assign SCE_gate_delayed = ~(SCE_delayed[1] & GATE_delayed[1]);

    // D-latch
    always @(posedge clkn) begin
        if (VPWR == 1'b1) begin
            m0 <= SCE_gate_delayed;
            notifier <= 1'b1;
        end else begin
            notifier <= 1'b0;
        end
    end

    // AND gate for output
    always @(posedge CLK) begin
        awake <= (VPWR == 1'b1);
        SCE_awake <= (awake & (GATE_delayed[1] == 1'b0));
        GATE_awake <= (awake & (SCE_delayed[1] == 1'b0));
        GCLK <= (CLK_delayed[1] & m0n) & SCE_awake & GATE_awake;
    end

endmodule
module top_module(
    signal_a,
    signal_b,
    sleep_mode,
    result
);input [7:0] signal_a;
    input [7:0] signal_b;
    input sleep_mode;
    output reg [7:0] result; // Changed wire to reg to allow assignment in always block

    wire [7:0] shifted_signal_b;

    assign shifted_signal_b = signal_b << 1;

    always @(*) begin
        if (sleep_mode == 1'b1) begin
            result = 8'b00000000;
        end else begin
            result = signal_a + shifted_signal_b;
        end
    end

endmodule
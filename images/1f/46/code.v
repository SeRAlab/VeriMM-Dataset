module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    reg M; // Master latch output
    reg S; // Slave latch output

    always @(posedge CLK) begin
        M <= D; // Capture D on the rising edge of CLK
    end

    always @(negedge CLK) begin
        Q <= M; // Pass master output to slave output on falling edge of CLK
        Qn <= ~Q; // Inverted output
    end
endmodule
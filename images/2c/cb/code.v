module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    reg D_master;

    always @(posedge CLK) begin
        D_master <= D; // Master captures D on rising edge of CLK
    end

    always @(negedge CLK) begin
        Q <= D_master; // Slave captures master value on falling edge of CLK
        Qn <= ~Q;      // Inverted output
    end
endmodule
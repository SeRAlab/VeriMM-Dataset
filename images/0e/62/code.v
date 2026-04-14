module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    reg master_Q;

    always @(posedge CLK) begin
        master_Q <= D;  // Master latches on the rising edge
    end

    always @(negedge CLK) begin
        Q <= master_Q;  // Slave latches the value from master on falling edge
        Qn <= ~Q;       // Inverted output
    end
endmodule
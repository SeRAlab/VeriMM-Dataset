module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    reg master_Q;

    always @(posedge CLK) begin
        master_Q <= D; // Capture D on rising edge
    end

    always @(negedge CLK) begin
        Q <= master_Q; // Output Q on falling edge
        Qn <= ~master_Q; // Inverted output
    end
endmodule
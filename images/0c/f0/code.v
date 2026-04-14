module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    reg master_Q;

    always @(posedge CLK) begin
        master_Q <= D; // Capture on clock edge
    end

    always @(negedge CLK) begin
        Q <= master_Q; // Transfer to output on falling edge
        Qn <= ~master_Q; // Inverted output
    end
endmodule
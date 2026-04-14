module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    reg master;
    reg slave;

    always @(posedge CLK) begin
        master <= D; // Capture D on the rising edge
    end

    always @(negedge CLK) begin
        slave <= master; // Transfer to slave on falling edge
        Q <= slave;      // Output Q
        Qn <= ~slave;    // Output Qn
    end
endmodule
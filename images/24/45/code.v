module master_slave_d_latch (
    input D,
    input CLK,
    output reg Q
);
    reg master_Q;

    always @(posedge CLK) begin
        master_Q <= D;  // Capture D on the rising edge of CLK
    end

    always @(negedge CLK) begin
        Q <= master_Q;  // Transfer master_Q to Q on the falling edge of CLK
    end
endmodule
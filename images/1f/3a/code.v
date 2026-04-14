module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg D_master;

    always @(posedge CLK) begin
        D_master <= D; // Store D at the rising edge of CLK
    end

    always @(negedge CLK) begin
        Q <= D_master; // Output Q on the falling edge of CLK
    end
endmodule
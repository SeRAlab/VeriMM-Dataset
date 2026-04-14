module master_slave_d_latch (
    input wire D,
    input wire EN,
    input wire CLK,
    output reg Q
);
    reg master;
    reg slave;

    always @(posedge CLK) begin
        if (EN) begin
            master <= D; // Master latch captures D when EN is high
        end
    end

    always @(negedge CLK) begin
        slave <= master; // Slave latch captures master output when CLK goes low
    end

    always @(negedge CLK) begin
        Q <= slave; // Output Q follows the slave latch
    end
endmodule
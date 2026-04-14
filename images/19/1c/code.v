module master_slave_d_latch (
    input wire D,
    input wire CLK,
    input wire EN,
    output reg Q
);
    reg master, slave;

    always @(posedge CLK or negedge EN) begin
        if (!EN) begin
            master <= 1'b0; // Reset master when EN is low
            slave <= 1'b0;  // Reset slave when EN is low
        end else begin
            master <= D;    // Capture D on the rising edge
            slave <= master; // Transfer master to slave
        end
    end

    always @(posedge CLK) begin
        Q <= slave; // Output the value of slave
    end
endmodule
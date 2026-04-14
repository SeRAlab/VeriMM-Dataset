module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    reg master_latch;

    always @(posedge CLK) begin
        master_latch <= D; // Sample D when CLK is high
    end

    always @(negedge CLK) begin
        Q <= master_latch; // Update Q when CLK goes low
        Qn <= ~master_latch; // Update Qn
    end
endmodule
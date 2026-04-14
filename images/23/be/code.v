module master_slave_d_latch (
    input wire D,
    input wire EN,
    output reg Q,
    output reg Q_not
);
    reg master_Q;

    always @(posedge EN) begin
        master_Q <= D;
    end

    always @(negedge EN) begin
        Q <= master_Q;
        Q_not <= ~master_Q;
    end
endmodule
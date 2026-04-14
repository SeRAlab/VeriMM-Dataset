module master_slave_d_latch (
    input wire D,
    input wire E,
    output reg Q,
    output reg Q_not
);
    reg master;
    
    always @ (D or E) begin
        if (E) begin
            master <= D; // Capture D in the master latch
        end
    end
    
    always @ (E) begin
        if (!E) begin
            Q <= master; // Propagate to slave latch when E goes low
            Q_not <= ~master;
        end
    end
endmodule
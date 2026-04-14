module master_slave_d_latch (
    input D,
    input CLK,
    output reg Q,
    output reg Qn
);
    reg master_Q, master_Qn;

    // Master latch
    always @(posedge CLK) begin
        master_Q <= D;
        master_Qn <= ~D;
    end

    // Slave latch
    always @(negedge CLK) begin
        Q <= master_Q;
        Qn <= master_Qn;
    end
endmodule
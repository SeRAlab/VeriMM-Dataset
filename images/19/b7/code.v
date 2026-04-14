module master_slave_d_latch (
    input wire D,
    input wire E,
    output reg Q,
    output reg Qn
);

reg master;

always @(D or E) begin
    if (E) begin
        master = D; // Capture D when E is high
    end
end

always @(master or E) begin
    if (!E) begin
        Q = master;  // Output Q follows master when E is low
        Qn = ~master; // Output Qn is the complement of master
    end
end

endmodule
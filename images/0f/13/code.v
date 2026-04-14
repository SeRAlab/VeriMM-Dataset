module master_slave_d_latch (
    input wire D,
    input wire Enable,
    input wire Clock,
    output reg Q,
    output reg Qn
);
    reg master;
    
    always @(posedge Clock) begin
        if (Enable) begin
            master <= D; // Master latch captures D
        end
    end
    
    always @(posedge Clock) begin
        if (Enable) begin
            Q <= master; // Slave latch captures master output
            Qn <= ~Q;    // Qn is the complement of Q
        end
    end
endmodule
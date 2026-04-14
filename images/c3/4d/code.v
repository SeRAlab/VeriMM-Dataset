module binary_counter (
    input CLK,
    input RST,
    output [3:0] Q
);

    // Local signals
    wire [3:0] Q_next;

    // D flip-flops
    reg [3:0] Q_reg;
    always @(posedge CLK) begin
        if (RST) begin
            Q_reg <= 4'b0000;
        end else begin
            Q_reg <= Q_next;
        end
    end

    // Combinational logic
    assign Q_next = (Q_reg == 4'b1111) ? 4'b0000 : Q_reg + 1'b1;
    assign Q = Q_reg;

endmodule
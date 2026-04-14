module top_module(
    address,
    clock,
    q
);input [11:0] address;
    input clock;
    output [11:0] q;

    reg [11:0] q_reg;
    wire [11:0] q_wire;

    always @(posedge clock) begin
        if (address < 12'd2048) begin
            q_reg <= address + 12'd100;
        end else if (address <= 12'd4095) begin
            q_reg <= address - 12'd100;
        end else begin
            q_reg <= address;
        end
    end

    assign q_wire = q_reg;

    assign q = q_wire;

endmodule
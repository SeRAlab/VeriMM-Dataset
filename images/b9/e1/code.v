module top_module(
    address,
    clock,
    q
);input [11:0] address;
    input clock;
    output [11:0] q;

    reg [11:0] q_reg;

    always @(posedge clock) begin
        q_reg <= address;
    end

    assign q = (clock == 1'b1) ? address : q_reg;

endmodule
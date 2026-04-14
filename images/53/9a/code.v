module top_module(
    input        clk,
    input  [6:0] a,
    input        a_msb,
    output [14:0] b,
    output       b_msb
);wire c = a_msb & b[0];

    reg [14:0] b_reg = 0;

    always @(posedge clk) begin
        b_reg <= b_reg + {a_msb ? {8'd255, a} : {8'd0, a}};
    end

    assign b_msb = b_reg[15];
    assign b = {b_reg[14:0], c};

endmodule
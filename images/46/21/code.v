module register_8bit(clk, rst, en, D, Q);
    input clk, rst, en;
    input [7:0] D;
    output [7:0] Q;
    reg [7:0] Q;

    always @(posedge clk) begin
        if (rst)
            Q <= 8'b00000000;
        else if (en)
            Q <= D;
    end

endmodule
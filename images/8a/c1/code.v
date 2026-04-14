module register8bit (
    input clk,
    input rst,
    input load,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_reg <= 8'b00000000;
        else if (load)
            q_reg <= d;
    end

    assign q = q_reg;

endmodule
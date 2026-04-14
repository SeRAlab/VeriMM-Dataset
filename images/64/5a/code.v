module shift_reg_4bit(
    input wire clk,
    input wire rst,
    input wire data_in,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 4'b0000;
        else
            q <= {q[2:0], data_in};
    end

endmodule
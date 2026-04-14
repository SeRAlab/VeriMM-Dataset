module shift_register_8bit
    (
        input clk,
        input rst,
        input d,
        output reg [7:0] q
    );

    always @(posedge clk)
    begin
        if (rst)
            q <= 8'b00000000;
        else
            q <= {q[6:0], d};
    end

endmodule
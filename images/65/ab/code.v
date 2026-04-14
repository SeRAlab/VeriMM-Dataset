module shift_register_8bit(
    input d,
    input clk, rst, en, dir,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b0;
        else if (en) begin
            if (dir)
                q <= {d, q[7:1]};
            else
                q <= {q[6:0], d};
        end
    end
endmodule
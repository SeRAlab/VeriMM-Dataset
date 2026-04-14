module shift_register(
    input clk,
    input rst,
    input in,
    output reg [7:0] out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 8'b00000000;
        else
            out <= {out[6:0], in};
    end

endmodule
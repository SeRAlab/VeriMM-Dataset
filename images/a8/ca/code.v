module register8 (
    input clk,
    input ld,
    input rst,
    input [7:0] d,
    output reg [7:0] q
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b0;
        else if (ld)
            q <= d;
    end

endmodule
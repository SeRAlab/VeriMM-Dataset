module shift_register (
        input clk,
        input load,
        input shift,
        input rst,
        input [7:0] pdata,
        output reg [7:0] q);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b00000000;
        else if (load)
            q <= pdata;
        else if (shift)
            q <= {q[6:0], 1'b0};
    end

endmodule
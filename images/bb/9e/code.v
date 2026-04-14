module shift_register
    (
        input rst_n,
        input clk,
        input shift_enable,
        output reg [7:0] q
    );

    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n)
            q <= 8'd0;
        else if (shift_enable)
            q <= {q[6:0], 1'b0};
    end

endmodule
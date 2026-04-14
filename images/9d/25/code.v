module shift_register (
        input clk,
        input reset,
        input sin,
        output reg [3:0] q);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 4'b0000;
        else
            q <= {sin, q[3:1]};
    end

endmodule
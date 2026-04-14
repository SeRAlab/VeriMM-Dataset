module gray_code_counter (
    input clk,
    input reset,
    output reg [1:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 2'b00;
        else
            q <= {q[1] ^ q[0], ~q[0]};
    end

endmodule
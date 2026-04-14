module johnson_counter (
    input clk,
    input rst,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (rst)
            q <= 8'b00000001;
        else
            q <= {q[6:0], ~q[7]};
    end
endmodule
module johnson_counter (
    input clk,
    input rst,
    output reg [7:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b00000000;
        else
            q <= {~q[0], q[7:1]};
    end
endmodule
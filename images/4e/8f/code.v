module ring_counter_3bit (
    input wire clk,
    input wire rst,
    output reg [2:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 3'b001;
        else
            q <= {q[1:0], q[2]};
    end

endmodule
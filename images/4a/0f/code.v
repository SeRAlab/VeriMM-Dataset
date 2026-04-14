module johnson_counter_4bit(
    input wire clk,
    input wire rst,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 4'b0000;
        end else begin
            q <= {q[2:0], ~q[3]};
        end
    end
endmodule
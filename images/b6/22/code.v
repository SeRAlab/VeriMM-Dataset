module johnson_counter(
    input wire clk,
    input wire rst,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b0000000000000000;
        end else begin
            q <= {~q[15], q[15:1]};
        end
    end
endmodule
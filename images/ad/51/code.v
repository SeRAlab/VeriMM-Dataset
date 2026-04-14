module johnson_counter(
    input wire clk,
    input wire rst,
    output reg [11:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 12'b100000000000;
        end else begin
            q <= {~q[0], q[11:1]};
        end
    end
endmodule
module shift_register(
    input wire clk,
    input wire rst_n,
    input wire dir,
    input wire [3:0] d,
    output reg [3:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 4'b0000;
    end else if (dir) begin
        q <= {q[0], q[3:1]};
    end else begin
        q <= {q[2:0], q[3]};
    end
end

endmodule
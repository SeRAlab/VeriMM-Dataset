module shift_register(
    input wire clk,
    input wire rst_n,
    input wire shift,
    input wire load,
    input wire [3:0] d,
    output reg [3:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 4'b0000;
    end else if (load) begin
        q <= d;
    end else if (shift) begin
        q <= {1'b0, q[3:1]};
    end
end

endmodule
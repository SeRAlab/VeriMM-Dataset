module shift_register(
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 8'd0;
    end else if (load) begin
        q <= d;
    end else begin
        q <= {1'b0, q[7:1]};
    end
end

endmodule
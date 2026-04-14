module shift_register(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 8'b0;
    end else if (load) begin
        q <= d;
    end else begin
        q <= {q[6:0], 1'b0};
    end
end

endmodule
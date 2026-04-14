module top_module(
    input [7:0] address,
    input clock,
    output reg [127:0] q
);always @(posedge clock) begin
    if (address < 128) begin
        q <= {address, 120'b0};
    end else begin
        q <= {address, q[7:0], q[15:8], q[23:16], q[31:24], q[39:32], q[47:40], q[55:48], q[63:56], q[71:64], q[79:72], q[87:80], q[95:88], q[103:96], q[111:104], q[119:112]};
    end
end

endmodule
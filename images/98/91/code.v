module shift_register(
    input wire clk,
    input wire rst,
    input wire en,
    input wire load,
    input wire [3:0] d,
    output reg [3:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 4'b0000;
    end else if (load) begin
        q <= d;
    end else if (en) begin
        q <= {1'b0, q[3:1]};
    end
end

endmodule
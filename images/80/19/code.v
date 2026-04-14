module johnson_counter#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    output reg [WIDTH-1:0] q
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        q <= 0;
    end else begin
        q <= {~q[0], q[WIDTH-1:1]};
    end
end

endmodule
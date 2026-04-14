module shift_register (
    input clk,
    input rst,
    input load,
    input shift_left,
    input [15:0] parallel_in,
    output reg [15:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 16'b0;
    end else if (load) begin
        q <= parallel_in;
    end else if (shift_left) begin
        q <= {q[14:0], 1'b0}; // Shift left
    end else begin
        q <= {1'b0, q[15:1]}; // Shift right
    end
end

endmodule
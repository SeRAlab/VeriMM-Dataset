module shift_register (
    input clk,
    input [1:0] data_in,
    input dir,          // direction: 0 for left, 1 for right
    output reg [1:0] q
);

always @(posedge clk) begin
    if (dir == 0) begin
        // Shift left
        q <= {q[0], data_in[1]}; // Shift left and insert new data_in
    end else begin
        // Shift right
        q <= {data_in[0], q[1]}; // Shift right and insert new data_in
    end
end

endmodule
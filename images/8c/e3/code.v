module top_module (
    input clk,
    input shift_left,
    input [3:0] data_in,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_left)
            q <= {q[2:0], data_in[3]}; // Shift left
        else
            q <= {data_in[0], q[3:1]}; // Shift right
    end

endmodule
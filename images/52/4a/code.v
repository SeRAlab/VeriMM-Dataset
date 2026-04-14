module shift_register(
    input clk,
    input shift,
    input load,
    input [3:0] data_in,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (load)
            q <= data_in;
        else if (shift)
            q <= {q[2:0], 1'b0};
    end
endmodule
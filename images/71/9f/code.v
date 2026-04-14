module shift_register_4bit(
    input clk,
    input load,
    input [3:0] parallel_in,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (load)
            q <= parallel_in;
        else
            q <= {1'b0, q[3:1]};
    end
endmodule
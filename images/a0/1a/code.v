module bidirectional_shift_register (
    input clk,
    input reset,
    input en,
    input dir,
    output reg [7:0] q);
always @(posedge clk) begin
    if (reset)
        q <= 8'b00000000;
    else if (en) begin
        if (dir)
            q <= {q[6:0], 1'b0};
        else
            q <= {1'b0, q[7:1]};
    end
end
endmodule
module johnson_counter (
    input clk,
    input reset,
    input en,
    output reg [1:0] q);

always @(posedge clk) begin
    if (reset)
        q <= 2'b00;
    else if (en) begin
        q <= {~q[1], q[0]};
    end
end

endmodule
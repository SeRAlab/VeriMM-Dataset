module johnson_counter_3bit (
    input wire clk,
    input wire reset,
    output reg [2:0] q
    );

always @(posedge clk) begin
    if (reset) begin
        q <= 3'b000;
    end else begin
        q <= {q[1:0], ~q[2]};
    end
end

endmodule
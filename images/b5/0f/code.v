module johnson_counter (
    input wire clk,
    output reg [3:0] q
);

    always @(posedge clk) begin
        q <= {~q[0], q[3:1]};
    end

endmodule
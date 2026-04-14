module johnson_counter (
    input clk,
    output reg [2:0] Q
);

    always @(posedge clk) begin
        Q <= {~Q[2], Q[2:1]};
    end

endmodule
module johnson_counter (
    input clk,
    input reset,
    output reg [5:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 6'b0;
        end else begin
            count <= {~count[0], count[5:1]};
        end
    end

endmodule
module down_counter(
    input clk,
    input reset,
    output reg [6:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 7'b1111111;
        end else begin
            count <= count - 1;
        end
    end

endmodule
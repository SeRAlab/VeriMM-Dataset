module up_counter(
    input clk,
    input reset,
    output reg [7:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 8'b00000000;
        end else begin
            count <= count + 1;
        end
    end

endmodule
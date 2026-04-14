module down_counter (
    input clk,
    input reset,
    input enable,
    output reg [2:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b111;
        end else if (enable) begin
            count <= count - 1;
        end
    end

endmodule
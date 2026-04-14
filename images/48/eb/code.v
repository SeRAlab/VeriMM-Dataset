module down_counter (
    input clk,
    input enable,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (enable) begin
            count <= count - 1;
        end
    end

endmodule
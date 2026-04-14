module top_module (
    input clk,
    input enable,
    output reg [3:0] count
);

    // 4-bit synchronous counter with enable logic
    always @(posedge clk) begin
        if (enable) begin
            count <= count + 1;
        end
    end

endmodule
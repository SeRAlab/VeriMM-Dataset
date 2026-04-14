module counter_3bit (
    input clk,
    input enable,
    input reset,
    output reg [2:0] count
);

    // Counter logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
        end else if (enable) begin
            count <= count + 1;
        end
    end

endmodule
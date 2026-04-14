module top_module (
    input clk,
    input up,
    input down,
    output reg [2:0] count
);

    // 3-bit up/down counter logic
    always @(posedge clk) begin
        if (up) begin
            count <= count + 1;
        end else if (down) begin
            count <= count - 1;
        end
    end

endmodule
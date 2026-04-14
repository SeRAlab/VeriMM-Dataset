module frequency_divider (
    input clk,
    output reg out
);

    reg [1:0] count; // 2-bit counter

    always @(posedge clk) begin
        count <= count + 1;
        if (count == 2'd3) begin
            out <= ~out; // Toggle output every 4 clock cycles
            count <= 2'd0; // Reset count
        end
    end

    initial begin
        out = 1'b0; // Initialize output
        count = 2'd0; // Initialize count
    end
endmodule
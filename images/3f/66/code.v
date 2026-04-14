module freq_divider (
    input clk,
    input reset,
    output reg out
);
    reg [2:0] count; // 3-bit counter to count to 8

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            out <= 1'b0;
        end else begin
            if (count == 3'b111) begin
                out <= ~out; // toggle output
                count <= 3'b000; // reset count
            end else begin
                count <= count + 1; // increment count
            end
        end
    end
endmodule
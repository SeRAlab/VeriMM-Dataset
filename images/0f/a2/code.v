module divide_by_4 (
    input wire clk,
    input wire reset,
    output reg out
);
    reg [1:0] count; // 2-bit counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
            out <= 1'b0;
        end else begin
            count <= count + 1;
            if (count == 2'b11) begin
                out <= ~out; // Toggle the output every four clock cycles
            end
        end
    end
endmodule
module shift_register (
    input clk,
    input reset,
    input shift,
    output reg [3:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 4'b0001;
        end else if (shift) begin
            out <= out << 1;
        end
    end
endmodule
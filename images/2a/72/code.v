module reset_controller (
    input wire clk,
    input wire reset,
    output reg [3:0] out
);
    always @(posedge clk) begin
        if (reset) begin
            out <= 4'b0000; // Reset output to 0
        end else begin
            out <= out + 1; // Increment output
        end
    end
endmodule
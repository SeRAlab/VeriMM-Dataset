module reset_controller(
    input wire clk,
    input wire reset,
    output reg [2:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 3'b000; // Reset output to 0
        end else begin
            out <= out + 1; // Increment output
            if (out == 3'b111) begin
                out <= 3'b000; // Wrap around when reaching 8
            end
        end
    end
endmodule
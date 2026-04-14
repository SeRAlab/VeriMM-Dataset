module johnson_counter
(
    input clk,
    input reset,
    output reg [4:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 5'b00000; // Reset counter to 00000
        end else begin
            count <= {count[3:0], ~count[4]}; // Johnson sequence
        end
    end

endmodule
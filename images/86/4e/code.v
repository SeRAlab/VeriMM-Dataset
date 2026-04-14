module johnson_counter
(
    input clk,
    input reset,
    output reg [3:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Clear counter to 0
        end else begin
            count <= {count[2:0], ~count[3]}; // Johnson counter logic
        end
    end

endmodule